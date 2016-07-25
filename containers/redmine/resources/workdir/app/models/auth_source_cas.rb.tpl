# require 'net/ldap'
# require 'net/ldap/dn'
# require 'timeout'
require 'net/http'
require 'net/https'

class AuthSourceCas < AuthSource
  NETWORK_EXCEPTIONS = [
    Errno::ECONNABORTED, Errno::ECONNREFUSED, Errno::ECONNRESET,
    Errno::EHOSTDOWN, Errno::EHOSTUNREACH,
    SocketError
  ]

  FQDN = '${FQDN}'

  def add_user_to_group(groupname, user)
    begin
      @group = Group.find_by(lastname: groupname.downcase)
      if @group.to_s == ''  # group does not exist
        # create group and add user
        create_group_with_user(groupname, user)
      else
        # if not already: add user to existing group
        @groupusers = User.active.in_group(@group).all()
        if not(@groupusers.include?(user))
          @group.users << user
        end
      end
    rescue Exception => e
      logger.info e.message
    end
  end

  def api_request(uri, form_data)
    http_uri = URI.parse(uri)
    http = Net::HTTP.new(http_uri.host,http_uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(http_uri.path, initheader = {'Content-Type' =>'application/json'})
    request.set_form_data(form_data)
    return http.request(request)
  end

  def authenticate(login, password)
    return nil if login.blank? || password.blank?

    # request a ticket granting ticket
    tgt_uri = 'https://'+FQDN+'/cas/v1/tickets'
    tgt_form_data = {'username' => login, 'password' => password}
    tgt = api_request(tgt_uri, tgt_form_data)

    if tgt.code == '201'
      # get ticket granting ticket from response
      forms = Nokogiri::HTML(tgt.body).xpath('//form').to_s
      sub=forms.index('https')
      sub2=forms.index('method')
      tgticket = forms.to_s[sub,sub2-sub-2]
      # request a service ticket
      st_uri = tgticket
      st_form_data = {'service' => 'https://'+FQDN+'/redmine'}
      serviceTicket = api_request(st_uri, st_form_data)

      if serviceTicket.code == '200'
        # get user information from cas and parse it to retVal
        sv_uri = 'https://'+FQDN+'/cas/p3/serviceValidate'
        sv_form_data = {'service' => 'https://'+FQDN+'/redmine', 'ticket' => serviceTicket.body}
        serviceVali = api_request(sv_uri, sv_form_data)

        # check if validation was successful
        if (Nokogiri::XML(serviceVali.body).xpath('//cas:serviceResponse').to_s).include? 'Success'
          userAttributes = Nokogiri::XML(serviceVali.body)
          user_mail = userAttributes.at_xpath('//cas:authenticationSuccess//cas:attributes//cas:mail').content.to_s
          user_surname = userAttributes.at_xpath('//cas:authenticationSuccess//cas:attributes//cas:surname').content.to_s
          user_givenName = userAttributes.at_xpath('//cas:authenticationSuccess//cas:attributes//cas:givenName').content.to_s
          user_groups = userAttributes.xpath('//cas:authenticationSuccess//cas:attributes//cas:groups')

          # Get ces admin group
          admingroup_exists = false
          ces_admin_group = (%x(etcdctl --peers $(cat /etc/ces/node_master):4001 get '/config/_global/admin_group')).to_s
          if ces_admin_group != nil
            admingroup_exists = true
          end

          user = User.find_by_login(login)
          if user == nil # user not in redmine yet
            user = User.new
            user.login = login
            user.firstname = user_givenName
            user.lastname = user_surname
            user.mail = user_mail
            user.auth_source_id = self.id
            if admingroup_exists
              if user_groups.to_s.include?(ces_admin_group.gsub(\"\n\",\"\"))
                user.admin = 1
              end
            end

            for i in user_groups
              # create group / add user to group
              add_user_to_group(i.content.to_s, user)
            end
          else # user already in redmine
            @usergroups = Array.new
            for i in user_groups
              @usergroups << i.content.to_s
              # create group / add user to group
              add_user_to_group(i.content.to_s, user)
            end
            # remove user from groups he is not in any more
            @casgroups = Group.where(firstname: 'cas')
            for l in @casgroups
              @casgroup = Group.find_by(lastname: l.to_s)
              @casgroupusers = User.active.in_group(@casgroup).all()
              for m in @casgroupusers
                if (m.login == login) and not(@usergroups.include?(l.to_s))
                  @casgroup.users.delete(user)
                end
              end
            end
            # remove user's admin rights if he is not in admin group any more
            if admingroup_exists
              if not (user_groups.to_s.include?(ces_admin_group.gsub(\"\n\",\"\")))
                user.admin = 0
                user.save
              end
            end
          end
          # return new user information
          retVal =
          {
            :firstname => user_givenName,
            :lastname => user_surname,
            :mail => user_mail,
            :auth_source_id => self.id
          }
          return retVal
        else
          raise 'Service ticket validation failure'
        end
      else
        raise 'No Service ticket granted'
        return nil
      end
    else
      raise 'Authentication data not accepted'
    end
    return nil
  rescue *NETWORK_EXCEPTIONS => e
    raise AuthSourceException.new(e.message)
  end

  def auth_method_name
    'CAS'
  end

  def create_group_with_user(group, user)
    # create group and add user
    @newgroup = Group.new(:lastname => group, :firstname => 'cas')
    @newgroup.users << user
    @newgroup.save!
  end

end

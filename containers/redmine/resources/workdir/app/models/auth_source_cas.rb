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

  # validates_presence_of :host, :port, :attr_login
  # validates_length_of :name, :host, :maximum => 60, :allow_nil => true
  # validates_length_of :account, :account_password, :base_dn, :maximum => 255, :allow_blank => true
  # validates_length_of :attr_login, :attr_firstname, :attr_lastname, :attr_mail, :maximum => 30, :allow_nil => true
  # validates_numericality_of :port, :only_integer => true
  # validates_numericality_of :timeout, :only_integer => true, :allow_blank => true
  # validate :validate_filter
  #
  # before_validation :strip_ldap_attributes

  # def initialize(attributes=nil, *args)
  #   super
  #   self.port = 389 if self.port == 0
  # end

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

    # authentication is successful if return value is not nil

    # request a ticket granting ticket
    # TODO: change hardcoded URL
    tgt_uri = 'https://192.168.115.142/cas/v1/tickets'
    tgt_form_data = {"username" => login, "password" => password}
    response1 = api_request(tgt_uri, tgt_form_data)

    if response1.code == "201"
      # get ticket granting ticket from response
      forms = Nokogiri::HTML(response1.body).xpath("//form").to_s
      sub=forms.index('https')
      sub2=forms.index('method')
      tgticket = forms.to_s[sub,sub2-sub-2]
      # request a service ticket
      st_uri = tgticket
      # TODO: change hardcoded URL
      st_form_data = {"service" => "https://192.168.115.142/redmine"}
      serviceTicket = api_request(st_uri, st_form_data)

      if serviceTicket.code == "200"
        # get user information from cas and parse it to retVal
        # TODO: change hardcoded URL
        sv_uri = 'https://192.168.115.142/cas/p3/serviceValidate'
        sv_form_data = {"service" => "https://192.168.115.142/redmine", "ticket" => serviceTicket.body}
        serviceVali = api_request(sv_uri, sv_form_data)

        # TODO: check if validation was successful
        userAttributes = Nokogiri::XML(serviceVali.body)
        # user_name = userAttributes.at_xpath("//cas:authenticationSuccess//cas:user").content.to_s
        user_mail = userAttributes.at_xpath("//cas:authenticationSuccess//cas:attributes//cas:mail").content.to_s
        user_surname = userAttributes.at_xpath("//cas:authenticationSuccess//cas:attributes//cas:surname").content.to_s
        # user_displayName = userAttributes.at_xpath("//cas:authenticationSuccess//cas:attributes//cas:displayName").content.to_s
        user_givenName = userAttributes.at_xpath("//cas:authenticationSuccess//cas:attributes//cas:givenName").content.to_s
        # user_cn = userAttributes.at_xpath("//cas:authenticationSuccess//cas:attributes//cas:cn").content.to_s
        # user_username = userAttributes.at_xpath("//cas:authenticationSuccess//cas:attributes//cas:username").content.to_s

        user_groups = userAttributes.xpath("//cas:authenticationSuccess//cas:attributes//cas:groups")
        user = User.find_by_login(login)
        if user == nil
          # user not in redmine yet
          user = User.new
          user.login = login
          user.firstname = user_givenName
          user.lastname = user_surname
          user.mail = user_mail
          user.auth_source_id = self.id

          for i in user_groups
            # create group / add user to group
            begin
              group = Group.find_by(lastname: i.content.to_s.downcase)
              if group.to_s == ""
                # group does not exist
                # create group and add user
                @newgroup = Group.new(:lastname => i.content.to_s, :firstname => "cas")
                @newgroup.users << user
                @newgroup.save!
              else
                # add user to existing group
                group.users << user
              end
            rescue Exception => e
              logger.info e.message
            end
          end
        else
          # user already in redmine
          @usergroups = Array.new
          for i in user_groups
            @usergroups << i.content.to_s
            # create group / add user to group
            begin
              group = Group.find_by(lastname: i.content.to_s.downcase)
              if group.to_s == ""  # group does not exist
                # create group and add user
                @newgroup = Group.new(:lastname => i.content.to_s, :firstname => "cas")
                @newgroup.users << user
                @newgroup.save!
              else
                # if not already: add user to existing group
                @groupusers = User.active.in_group(group).all()
                if not(@groupusers.include?(user))
                  group.users << user
                end
              end
            rescue Exception => e
              logger.info e.message
            end
          end
          # remove user from groups he is not in any more
          @casgroups = Group.where(firstname: "cas")
          for l in @casgroups
            @casgroup = Group.find_by(lastname: l.to_s)
            @casgroupusers = User.active.in_group(@casgroup).all()
            for m in @casgroupusers
              if (m.login == login) and not(@usergroups.include?(l.to_s))
                @casgroup.users.delete(user)
              end
            end
          end
        end

        retVal =
          {
            :firstname => user_givenName,
            :lastname => user_surname,
            :mail => user_mail,
            :auth_source_id => self.id
          }
        return retVal
      else
        raise "No Service ticket granted."
        return nil
      end
    else
      raise "Authentication data not accepted"
    end
    return nil
  rescue *NETWORK_EXCEPTIONS => e
    raise AuthSourceException.new(e.message)
  end

  # # Test the connection to the LDAP
  # def test_connection
  #   with_timeout do
  #     ldap_con = initialize_ldap_con(self.account, self.account_password)
  #     ldap_con.open { }
  #
  #     if self.account.present? && !self.account.include?("$login") && self.account_password.present?
  #       ldap_auth = authenticate_dn(self.account, self.account_password)
  #       raise AuthSourceException.new(l(:error_ldap_bind_credentials)) if !ldap_auth
  #     end
  #   end
  # rescue *NETWORK_EXCEPTIONS => e
  #   raise AuthSourceException.new(e.message)
  # end

  def auth_method_name
    "CAS"
  end

  # # Returns true if this source can be searched for users
  # def searchable?
  #   !account.to_s.include?("$login") && %w(login firstname lastname mail).all? {|a| send("attr_#{a}?")}
  # end
  #
  # # Searches the source for users and returns an array of results
  # def search(q)
  #   q = q.to_s.strip
  #   return [] unless searchable? && q.present?
  #
  #   results = []
  #   search_filter = base_filter & Net::LDAP::Filter.begins(self.attr_login, q)
  #   ldap_con = initialize_ldap_con(self.account, self.account_password)
  #   ldap_con.search(:base => self.base_dn,
  #                   :filter => search_filter,
  #                   :attributes => ['dn', self.attr_login, self.attr_firstname, self.attr_lastname, self.attr_mail],
  #                   :size => 10) do |entry|
  #     attrs = get_user_attributes_from_ldap_entry(entry)
  #     attrs[:login] = AuthSourceLdap.get_attr(entry, self.attr_login)
  #     results << attrs
  #   end
  #   results
  # rescue *NETWORK_EXCEPTIONS => e
  #   raise AuthSourceException.new(e.message)
  # end

  # private

  # def with_timeout(&block)
  #   timeout = self.timeout
  #   timeout = 20 unless timeout && timeout > 0
  #   Timeout.timeout(timeout) do
  #     return yield
  #   end
  # rescue Timeout::Error => e
  #   raise AuthSourceTimeoutException.new(e.message)
  # end
  #
  # def ldap_filter
  #   if filter.present?
  #     Net::LDAP::Filter.construct(filter)
  #   end
  # rescue Net::LDAP::LdapError, Net::LDAP::FilterSyntaxInvalidError
  #   nil
  # end
  #
  # def base_filter
  #   filter = Net::LDAP::Filter.eq("objectClass", "*")
  #   if f = ldap_filter
  #     filter = filter & f
  #   end
  #   filter
  # end
  #
  # def validate_filter
  #   if filter.present? && ldap_filter.nil?
  #     errors.add(:filter, :invalid)
  #   end
  # end
  #
  # def strip_ldap_attributes
  #   [:attr_login, :attr_firstname, :attr_lastname, :attr_mail].each do |attr|
  #     write_attribute(attr, read_attribute(attr).strip) unless read_attribute(attr).nil?
  #   end
  # end
  #
  # def initialize_ldap_con(ldap_user, ldap_password)
  #   options = { :host => self.host,
  #               :port => self.port,
  #               :encryption => (self.tls ? :simple_tls : nil)
  #             }
  #   options.merge!(:auth => { :method => :simple, :username => ldap_user, :password => ldap_password }) unless ldap_user.blank? && ldap_password.blank?
  #   Net::LDAP.new options
  # end
  #
  # def get_user_attributes_from_ldap_entry(entry)
  #   {
  #    :dn => entry.dn,
  #    :firstname => AuthSourceLdap.get_attr(entry, self.attr_firstname),
  #    :lastname => AuthSourceLdap.get_attr(entry, self.attr_lastname),
  #    :mail => AuthSourceLdap.get_attr(entry, self.attr_mail),
  #    :auth_source_id => self.id
  #   }
  # end
  #
  # # Return the attributes needed for the LDAP search.  It will only
  # # include the user attributes if on-the-fly registration is enabled
  # def search_attributes
  #   if onthefly_register?
  #     ['dn', self.attr_firstname, self.attr_lastname, self.attr_mail]
  #   else
  #     ['dn']
  #   end
  # end
  #
  # # Check if a DN (user record) authenticates with the password
  # def authenticate_dn(dn, password)
  #   if dn.present? && password.present?
  #     initialize_ldap_con(dn, password).bind
  #   end
  # end
  #
  # Get the user's dn and any attributes for them, given their login
  # def get_user_dn(login, password)
  #   ldap_con = nil
  #   if self.account && self.account.include?("$login")
  #     ldap_con = initialize_ldap_con(self.account.sub("$login", Net::LDAP::DN.escape(login)), password)
  #   else
  #     ldap_con = initialize_ldap_con(self.account, self.account_password)
  #   end
  #   attrs = {}
  #   search_filter = base_filter & Net::LDAP::Filter.eq(self.attr_login, login)
  #   ldap_con.search( :base => self.base_dn,
  #                    :filter => search_filter,
  #                    :attributes=> search_attributes) do |entry|
  #     if onthefly_register?
  #       attrs = get_user_attributes_from_ldap_entry(entry)
  #     else
  #       attrs = {:dn => entry.dn}
  #     end
  #     logger.debug "DN found for #{login}: #{attrs[:dn]}" if logger && logger.debug?
  #   end
  #   attrs
  # end
  #
  # def self.get_attr(entry, attr_name)
  #   if !attr_name.blank?
  #     value = entry[attr_name].is_a?(Array) ? entry[attr_name].first : entry[attr_name]
  #     value.to_s.force_encoding('UTF-8')
  #   end
  # end
end

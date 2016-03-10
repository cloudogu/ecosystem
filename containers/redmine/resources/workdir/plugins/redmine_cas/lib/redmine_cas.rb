require 'casclient'
require 'casclient/frameworks/rails/filter'

module RedmineCAS
  extend self

  def setting(name)
    Setting.plugin_redmine_cas[name]
  end

  def enabled?
    setting(:enabled)
  end

  def autocreate_users?
    setting(:autocreate_users)
  end

  def setup!
    return unless enabled?
    CASClient::Frameworks::Rails::Filter.configure(
      :cas_base_url => setting(:cas_url),
      :logger => Rails.logger,
      :validate_url  => setting(:cas_url)+"/p3/proxyValidate",
      :enable_single_sign_out => single_sign_out_enabled?
    )
  end

  def single_sign_out_enabled?
    ActiveRecord::Base.connection.table_exists?(:sessions)
  end

  def user_extra_attributes_from_session(session)
    attrs = {}
    map = Rack::Utils.parse_nested_query setting(:attributes_mapping)
    extra_attributes = session[:cas_extra_attributes] || {}
    map.each_pair do |key_redmine, key_cas|
      value = extra_attributes[key_cas]
      if User.attribute_method?(key_redmine) && value
        attrs[key_redmine] = (value.is_a? Array) ? value.first : value
      end
    end
    attrs
  end
end

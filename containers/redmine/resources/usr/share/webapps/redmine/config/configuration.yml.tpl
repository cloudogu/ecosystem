default:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: \"${RELAYHOST}\"
      port: 25
      domain: '${DOMAIN}'
  attachments_storage_path:
  autologin_cookie_name:
  autologin_cookie_path:
  autologin_cookie_secure:
  scm_subversion_command:
  scm_mercurial_command:
  scm_git_command:
  scm_cvs_command:
  scm_bazaar_command:
  scm_darcs_command:
  scm_subversion_path_regexp:
  scm_mercurial_path_regexp:
  scm_git_path_regexp:
  scm_cvs_path_regexp:
  scm_bazaar_path_regexp:
  scm_darcs_path_regexp:
  scm_filesystem_path_regexp:
  scm_stderr_log_file:
  database_cipher_key:
  rmagick_font_path:
production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: \"${RELAYHOST}\"
      port: 25
      domain: '${DOMAIN}'
# that overrides the default ones
development:

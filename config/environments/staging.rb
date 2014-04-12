require File.expand_path('../production', __FILE__)

Jobrunner::Application.configure do
  #Configuration
  config.system_email = "staging@contacts.pmgdirect.net"
  config.action_mailer.default_url_options = { host: 'jobrunner-staging.herokuapp.com' }
end

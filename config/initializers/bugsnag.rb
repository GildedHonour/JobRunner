if  Rails.application.secrets.bugsnag_api_key.present?
  Bugsnag.configure do |config|
    config.notify_release_stages = [ 'production' ]
    config.use_ssl = true
  end
end

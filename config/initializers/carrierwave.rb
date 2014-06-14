require 'carrierwave/orm/activerecord'
include CarrierWave::RMagick

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key
    }
    config.fog_directory  = Rails.application.secrets.s3_bucket
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    config.fog_public = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end

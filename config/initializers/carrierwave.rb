require 'carrierwave/orm/activerecord'
include CarrierWave::RMagick

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: '12VDZMD0HMNA6YZP49R2',
      aws_secret_access_key: 'Jfexmny33Fy7fBl1fmzl3Ptk/0NvPnbR3AgFL55c'
    }
    config.fog_directory  = 'jobrunner-staging'
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    config.asset_host = "//jobrunner-staging.s3.amazonaws.com"
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
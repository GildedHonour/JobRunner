class CompanyLogoUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [120, 120]

  version :mini_thumb do
    process resize_to_fill: [50,50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
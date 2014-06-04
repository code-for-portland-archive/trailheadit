class TrailheadphotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  # process :scale => [800, 800]

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [150, 150]
  end

  version :small do
    process :resize_to_fit => [500, 500]
  end

  # def extension_white_list
  #   %w(jpg jpeg)
  # end
end

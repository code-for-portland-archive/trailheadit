class TrailheadphotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production? || Rails.env.staging?
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

  version :oriented do
    process :auto_orient    
  end

  version :large, :from_version => :oriented do
    process :resize_to_fit => [1000, 1000]
  end

  version :small_square, :from_version => :oriented do
    process :resize_to_fill => [500, 500]
  end

  version :small, :from_version => :oriented do
    process :resize_to_fit => [500, 500]
  end

  version :mini_square, :from_version => :oriented do
    process :resize_to_fill => [300, 300]
  end

  # Create different versions of your uploaded files:
  version :thumb, :from_version => :small do    
    process :resize_to_fit => [150, 150]
  end

  # Create different versions of your uploaded files:
  version :thumb_square, :from_version => :small do    
    process :resize_to_fill => [150, 150]
  end

  def auto_orient
    manipulate! do |image|
      image.auto_orient      
      image
    end
  end

  # def extension_white_list
  #   %w(jpg jpeg)
  # end
end

CarrierWave.configure do |config|  
  config.storage :fog
  config.fog_credentials = {
    :provider               => 'AWS',                         # required
    :aws_access_key_id      =>  ENV['AWS_ACCESS_ID'],         # required
    :aws_secret_access_key  =>  ENV['AWS_ACCESS_KEY']         # required    
  }
  if Rails.env.production?
    config.fog_directory  = 'trailheadit'
  elsif Rails.env.staging?    
    config.fog_directory  = 'trailheaditstaging'
  else
    config.fog_directory  = 'trailheadit-local'
    config.storage = :file
    config.enable_processing = false
  end
  config.cache_dir = "#{Rails.root}/tmp/uploads" 
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
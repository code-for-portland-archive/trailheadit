class Trailhead < ActiveRecord::Base
  mount_uploader :photo, TrailheadphotoUploader
  belongs_to :user

  after_create :default_taken_at

  serialize :exif_properties, JSON
  serialize :email_properties, JSON

  scope :latest, -> { order('id DESC') } 

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch address

  #This method returns the GPS Latitude, Longitude, Timestamp
  #For a specified image.
  #Input: Image path for local JPG copy
  #Output: GPS.latitude, GPS.Longitude, Timestamp
  #Values may be "Nil" for cases missing Exif info in the JPG
  
  def default_taken_at
    self.taken_at ||= self.created_at
    self.save
  end

  def display_name
    name || latlng || "Untitled"
  end

  def latlng    
    if latitude && longitude
      [latitude.round(7),longitude.round(7)].compact.join(',')
    else
      "0,0"
    end
  end

  def exifXtractr(imgPath)   
    img_exif = EXIFR::JPEG.new(imgPath)
    return img_exif
  end

  def exif_data
    if Rails.env.development?
      test_path = photo.path
    else
      test_path = open(photo.url)        
    end
    img_exif = EXIFR::JPEG.new(test_path)
    return img_exif
  end

  def exif_json
    JSON.parse exif_data.to_json
  end

  def save_exif
    update_attributes(exif_properties:exif_json)
  end  

  def refresh
    photo.recreate_versions!
    self.exif_properties = exif_json
    reverse_geocode
    save
  end

  def to_geojson
    properties = {
        # trailIds:c.trails.collect(&:plats_id).join("; "),
        id:id,
        name:name,              
        kiosk:kiosk || false,
        parking:parking || false,
        restrooms:restrooms || false,
        drinkwater:drinking_water || false,
        photos: {
          large: photo.url(:oriented),
          small: photo.url(:small),
          thumb: photo.url(:thumb),
          square: photo.url(:thumb_square)
        }
        # address: address.to_s        
    }

    geometry = {
      type: "Point",
      coordinates: [longitude,latitude]
    }

    { 
      type:"Feature",
      properties:properties,
      geometry: geometry
    }
  end

  def self.to_geojson    
    features = self.all.select{|c| c.latitude && c.longitude}.collect do |c|                   
      c.to_geojson
    end

    geojson = {
      type: "FeatureCollection", 
      features: features 
    }

  end
    
end
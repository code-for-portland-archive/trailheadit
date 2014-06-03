class Trailhead < ActiveRecord::Base
  mount_uploader :photo, TrailheadphotoUploader
  belongs_to :user

  #This method returns the GPS Latitude, Longitude, Timestamp
  #For a specified image.
  #Input: Image path for local JPG copy
  #Output: GPS.latitude, GPS.Longitude, Timestamp
  #Values may be "Nil" for cases missing Exif info in the JPG
  
  def exifXtractr(imgPath)   
    img_exif = EXIFR::JPEG.new(imgPath)
    return img_exif
  end

  def exif_data
    test = open(photo.url)        
    img_exif = EXIFR::JPEG.new(test.path)
    return img_exif
  end

  def save_exif
    update_attributes(exif_properties:JSON.parse(exif_data.to_json))
  end  

  def to_geojson
    properties = {
        # trailIds:c.trails.collect(&:plats_id).join("; "),
        name:name,              
        kiosk:kiosk,
        parking:parking,
        restrooms:restrooms,
        drinkwater:drinking_water
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
    features = self.all.collect do |c|                   
      c.to_geojson
    end

    geojson = {
      type: "FeatureCollection", 
      features: features 
    }

  end
    
end
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
    img_exif = EXIFR::JPEG.new(photo.path)
    return img_exif
  end

  def save_exif
    update_attributes(exif_properties:JSON.parse(exif_data.to_json))
  end

  def to_plats_trailhead_geojson
    features = all_trailheads.collect do |c|             
      stewardId = c.plats_steward_id || self.plats_id.to_s
      properties = {
        # trailIds:c.trails.collect(&:plats_id).join("; "),
        name:c.name,      
        steward_id:stewardId,        
        address: c.address.to_s        
      }

      prop_tags = ['kiosk','parking','drinkwater','restrooms']
      osm_hash = []
      c.osm_tags.order('value').each do |osm_tag|
        if prop_tags.include? osm_tag.key
          properties[osm_tag.key] = osm_tag.value
        else
          osm_hash << [osm_tag.key,osm_tag.value]
        end
      end

      properties[:trail_ids] = c.trails.collect(&:plats_id).sort.join(";")
      properties[:osm_tags] = osm_hash.collect{|c| "#{c[0]}=#{c[1]}"}.join(";")

      { 
        type:"Feature",
        properties:properties,
        geometry:Yajl::Parser.new.parse(c.geojson)
      }
    end

    geojson = {
      type: "FeatureCollection", 
      features: features 
    }.to_json

  end

  def self.to_plats_trailhead_geojson
    features = all_trailheads.collect do |c|             
      stewardId = c.plats_steward_id || self.plats_id.to_s
      properties = {
        # trailIds:c.trails.collect(&:plats_id).join("; "),
        name:c.name,      
        steward_id:stewardId,        
        address: c.address.to_s        
      }

      prop_tags = ['kiosk','parking','drinkwater','restrooms']
      osm_hash = []
      c.osm_tags.order('value').each do |osm_tag|
        if prop_tags.include? osm_tag.key
          properties[osm_tag.key] = osm_tag.value
        else
          osm_hash << [osm_tag.key,osm_tag.value]
        end
      end

      properties[:trail_ids] = c.trails.collect(&:plats_id).sort.join(";")
      properties[:osm_tags] = osm_hash.collect{|c| "#{c[0]}=#{c[1]}"}.join(";")

      { 
        type:"Feature",
        properties:properties,
        geometry:Yajl::Parser.new.parse(c.geojson)
      }
    end

    geojson = {
      type: "FeatureCollection", 
      features: features 
    }.to_json

  end
    
end
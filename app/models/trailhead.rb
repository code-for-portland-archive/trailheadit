class Trailhead < ActiveRecord::Base
  mount_uploader :photo, TrailheadphotoUploader

  #This method returns the GPS Latitude, Longitude, Timestamp
  #For a specified image.
  #Input: Image path for local JPG copy
  #Output: GPS.latitude, GPS.Longitude, Timestamp
  #Values may be "Nil" for cases missing Exif info in the JPG
  
  def exifXtractr(imgPath)   
    img_exif = EXIFR::JPEG.new(imgPath)
    return img_exif
  end
  
end
class Trailhead < ActiveRecord::Base
  mount_uploader :trailheadphoto, TrailheadphotoUploader
end

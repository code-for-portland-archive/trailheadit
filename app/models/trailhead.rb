class Trailhead < ActiveRecord::Base
  mount_uploader :photo, TrailheadphotoUploader
end

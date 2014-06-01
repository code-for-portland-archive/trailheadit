class AddPropsToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :email_properties, :json
    add_column :trailheads, :exif_properties, :json
  end
end

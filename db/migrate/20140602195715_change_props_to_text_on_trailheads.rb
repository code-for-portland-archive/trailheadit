class ChangePropsToTextOnTrailheads < ActiveRecord::Migration
  def change
    change_column :trailheads, :email_properties, :text
    change_column :trailheads, :exif_properties, :text
  end
end

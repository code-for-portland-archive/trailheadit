class AddExifToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :heading, :float
    add_column :trailheads, :taken_at, :datetime
    add_column :trailheads, :altitude, :float
  end
end

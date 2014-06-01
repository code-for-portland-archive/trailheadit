class AddViewedAtToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :viewed_at, :datetime
  end
end

class AddSocialToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :social, :boolean
    add_column :trailheads, :gated, :boolean
  end
end

class AddAddressToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :address, :text
  end
end

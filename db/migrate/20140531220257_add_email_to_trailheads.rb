class AddEmailToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :email, :string
  end
end

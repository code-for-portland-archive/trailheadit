class AddUserIdToTrailheads < ActiveRecord::Migration
  def change
    add_reference :trailheads, :user, index: true
  end
end

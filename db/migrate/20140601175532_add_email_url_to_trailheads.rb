class AddEmailUrlToTrailheads < ActiveRecord::Migration
  def change
    add_column :trailheads, :email_url, :string
  end
end

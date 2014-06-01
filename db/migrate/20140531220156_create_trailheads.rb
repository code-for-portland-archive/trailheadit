class CreateTrailheads < ActiveRecord::Migration
  def change
    create_table :trailheads do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :photo
      t.boolean :parking
      t.boolean :drinking_water
      t.boolean :restrooms
      t.boolean :kiosk

      t.timestamps
    end
  end
end

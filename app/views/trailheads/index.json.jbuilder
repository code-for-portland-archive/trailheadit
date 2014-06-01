json.array!(@trailheads) do |trailhead|
  json.extract! trailhead, :id, :name, :latitude, :longitude, :photo, :parking, :drinking_water, :restrooms, :kiosk
  json.url trailhead_url(trailhead, format: :json)
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trailhead do
    name "MyString"
    latitude 1.5
    longitude 1.5
    photo "MyString"
    parking false
    drinking_water false
    restrooms false
    kiosk false
  end
end

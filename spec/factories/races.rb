require 'faker'

FactoryGirl.define do
  factory :race do |f|
    f.name { Faker::Name.name }
    f.season_id 1
    f.track_id 1
  end
end

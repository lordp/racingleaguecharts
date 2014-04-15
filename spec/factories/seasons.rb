require 'faker'

FactoryGirl.define do
  factory :season do |f|
    f.name { Faker::Name.name }
    f.league_id 1
  end
end

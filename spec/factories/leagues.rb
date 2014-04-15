require 'faker'

FactoryGirl.define do
  factory :league do |f|
    f.name { Faker::Name.name }
    f.super_league_id 1
  end
end

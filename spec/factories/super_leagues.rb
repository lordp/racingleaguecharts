require 'faker'

FactoryGirl.define do
  factory :super_league do |f|
    f.name { Faker::Name.name }
  end
end

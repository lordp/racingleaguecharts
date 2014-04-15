require 'faker'

FactoryGirl.define do
  factory :track do |f|
    f.name { Faker::Name.name }
    f.length 1.234
  end
end

require 'faker'

FactoryGirl.define do
  factory :driver do |f|
    f.name { Faker::Name.name }
  end
end

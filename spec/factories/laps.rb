require 'faker'

FactoryGirl.define do
  factory :lap do |f|
    f.session_id 1
    f.sector_1 1
    f.sector_2 2
    f.sector_3 3
    f.total 6
    f.lap_number 1
  end
end

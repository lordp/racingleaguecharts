require 'faker'

FactoryGirl.define do
  factory :session do |f|
    f.driver_id 1
    f.track_id 1
    f.association :laps
  end

  factory :session_with_laps do |session|
    create(:lap, session: session, :total => 1)
    create(:lap, session: session, :total => 2)
    create(:lap, session: session, :total => 3)
  end
end

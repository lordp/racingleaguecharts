require 'spec_helper'

describe Session do
  it 'has a valid factory' do
    FactoryGirl.create(:session).should be_valid
  end

  it 'is invalid without a track id' do
    FactoryGirl.build(:session, :track_id => nil).should_not be_valid
  end

  it 'is invalid without a driver id' do
    FactoryGirl.build(:session, :driver_id => nil).should_not be_valid
  end

  it 'should return the correct lap for fastest lap method' do
    FactoryGirl.create(:session_with_laps).fastest_lap.total.should == 1
  end
end

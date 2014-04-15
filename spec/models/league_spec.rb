require 'spec_helper'

describe League do
  it 'has a valid factory' do
    FactoryGirl.create(:league).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:league, :name => nil).should_not be_valid
  end

  it 'is invalid without a super league' do
    FactoryGirl.build(:league, :name => 'Awesome', :super_league_id => nil).should_not be_valid
  end
end

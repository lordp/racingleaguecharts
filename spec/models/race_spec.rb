require 'spec_helper'

describe Race do
  it 'has a valid factory' do
    FactoryGirl.create(:race).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:race, :name => nil).should_not be_valid
  end

  it 'is invalid without a league' do
    FactoryGirl.build(:race, :name => 'Awesome', :season_id => nil).should_not be_valid
  end
end

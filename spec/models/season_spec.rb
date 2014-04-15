require 'spec_helper'

describe Season do
  it 'has a valid factory' do
    FactoryGirl.create(:season).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:season, :name => nil).should_not be_valid
  end

  it 'is invalid without a league' do
    FactoryGirl.build(:season, :name => 'Awesome', :league_id => nil).should_not be_valid
  end
end

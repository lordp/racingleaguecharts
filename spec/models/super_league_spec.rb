require 'spec_helper'

describe SuperLeague do
  it 'has a valid factory' do
    FactoryGirl.create(:super_league).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:super_league, :name => nil).should_not be_valid
  end

  it 'should reject duplicates' do
    FactoryGirl.create(:super_league, :name => 'Awesome')
    FactoryGirl.build(:super_league, :name => 'Awesome').should_not be_valid
  end
end

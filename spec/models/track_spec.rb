require 'spec_helper'

describe Track do
  it 'has a valid factory' do
    FactoryGirl.create(:track).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:track, :name => nil).should_not be_valid
  end

  it 'is invalid without a track length' do
    FactoryGirl.build(:track, :length => nil).should_not be_valid
  end

  it 'is invalid with a track length that isn\'t a number' do
    FactoryGirl.build(:track, :length => 'a').should_not be_valid
  end
end

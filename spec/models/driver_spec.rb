require 'spec_helper'

describe Driver do
  it 'has a valid factory' do
    FactoryGirl.create(:driver).should be_valid
  end

  it 'is invalid without a name' do
    FactoryGirl.build(:driver, :name => nil).should_not be_valid
  end

  it 'should reject duplicates' do
    FactoryGirl.create(:driver, :name => 'Awesome')
    FactoryGirl.build(:driver, :name => 'Awesome').should_not be_valid
  end
end

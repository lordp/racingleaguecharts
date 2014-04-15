require 'spec_helper'

describe Lap do
  it 'has a valid factory' do
    FactoryGirl.create(:lap).should be_valid
  end
end

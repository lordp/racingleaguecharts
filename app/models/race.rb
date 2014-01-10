class Race < ActiveRecord::Base
  attr_accessible :name, :session_ids

  has_many :sessions
  #accepts_nested_attributes_for :sessions
end

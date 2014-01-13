class Race < ActiveRecord::Base
  attr_accessible :name, :session_ids, :track_id

  has_many :sessions
  belongs_to :track
  belongs_to :season
end

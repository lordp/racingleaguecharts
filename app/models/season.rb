class Season < ActiveRecord::Base
  attr_accessible :league_id, :name

  belongs_to :league
end

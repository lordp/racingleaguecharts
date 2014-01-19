class SetTrackIdOnRaces < ActiveRecord::Migration
  def up
    Race.all.each do |race|
      race.update_attribute(:track_id, race.sessions.first.try(:track_id))
    end
  end
end

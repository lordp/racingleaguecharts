class SetTrackIdOnRaces < ActiveRecord::Migration
  def up
    Race.all.each do |race|
      race.update_attribute(:race_id, race.sessions.first.track_id)
    end
  end
end

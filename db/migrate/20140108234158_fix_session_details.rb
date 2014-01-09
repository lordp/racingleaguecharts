class FixSessionDetails < ActiveRecord::Migration
  def up
    Session.all.each do |session|
      session.update_attribute(:driver_id, session.laps.first.try(:driver_id))
      session.update_attribute(:track_id, session.laps.first.try(:race_id))
    end
  end

  def down
    Session.all.each do |session|
      session.update_attribute(:driver_id, nil)
      session.update_attribute(:track_id, nil)
    end
  end
end

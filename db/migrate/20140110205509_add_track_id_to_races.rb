class AddTrackIdToRaces < ActiveRecord::Migration
  def change
    add_column :races, :track_id, :integer
  end
end

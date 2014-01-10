class UpdateRaceModel < ActiveRecord::Migration
  def change
    change_table :races do |t|
      t.remove(:length)
      t.timestamps
    end
  end
end

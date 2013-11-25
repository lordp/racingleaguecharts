class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.float :track_length

      t.timestamps
    end
  end
end

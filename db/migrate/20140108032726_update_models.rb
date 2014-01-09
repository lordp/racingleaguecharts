class UpdateModels < ActiveRecord::Migration
  def up
    create_table :tracks do |t|
      t.string :name
      t.float :length

      t.timestamps
    end

    Race.all.each do |race|
      Track.create(:name => race.name, :length => race.length)
    end

    change_table :sessions do |t|
      t.integer :driver_id
      t.integer :track_id
      t.timestamps
    end
  end

  def down
    drop_table :tracks
  end
end

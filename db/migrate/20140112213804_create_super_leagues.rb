class CreateSuperLeagues < ActiveRecord::Migration
  def change
    create_table :super_leagues do |t|
      t.string :name

      t.timestamps
    end
  end
end

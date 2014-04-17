class CreateDriverAliases < ActiveRecord::Migration
  def change
    create_table :driver_aliases do |t|
      t.integer :driver_id
      t.string :name

      t.timestamps
    end
  end
end

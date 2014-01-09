class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.integer :session_id
      t.text :parsed
      t.string :image

      t.timestamps
    end
  end
end

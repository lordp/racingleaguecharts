class AddFiaToRaces < ActiveRecord::Migration
  def change
    add_column :races, :fia, :boolean
  end
end

class AddFlagToRaces < ActiveRecord::Migration
  def change
    add_column :races, :flag, :string
  end
end

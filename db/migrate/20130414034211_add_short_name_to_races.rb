class AddShortNameToRaces < ActiveRecord::Migration
  def change
    add_column :races, :short_name, :string
  end
end

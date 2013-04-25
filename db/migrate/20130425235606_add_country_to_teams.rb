class AddCountryToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :country, :string
  end
end

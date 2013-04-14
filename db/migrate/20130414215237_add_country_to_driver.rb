class AddCountryToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :country, :string
  end
end

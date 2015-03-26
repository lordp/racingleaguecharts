class AddDisabledToSuperLeagues < ActiveRecord::Migration
  def change
    add_column :super_leagues, :disabled, :boolean, :default => false
  end
end

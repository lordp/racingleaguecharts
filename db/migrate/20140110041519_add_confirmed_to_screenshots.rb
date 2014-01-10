class AddConfirmedToScreenshots < ActiveRecord::Migration
  def change
    add_column :screenshots, :confirmed, :boolean
  end
end

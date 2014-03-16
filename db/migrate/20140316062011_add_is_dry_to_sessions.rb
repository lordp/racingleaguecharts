class AddIsDryToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :is_dry, :boolean
  end
end

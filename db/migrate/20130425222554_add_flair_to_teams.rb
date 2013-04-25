class AddFlairToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :flair, :string
  end
end

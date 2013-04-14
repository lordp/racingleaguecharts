class AddTeamToResult < ActiveRecord::Migration
  def change
    add_column :results, :team_id, :integer
  end
end

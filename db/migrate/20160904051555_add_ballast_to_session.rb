class AddBallastToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :ballast, :integer
  end
end

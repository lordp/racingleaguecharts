class AddStartDateToRaces < ActiveRecord::Migration
  def change
    add_column :races, :start_date, :datetime
  end
end

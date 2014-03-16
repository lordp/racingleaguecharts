class AddTimeTrialToRaces < ActiveRecord::Migration
  def change
    add_column :races, :time_trial, :boolean
  end
end

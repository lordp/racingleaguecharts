class AddTimeTrialToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :time_trial, :boolean
  end
end

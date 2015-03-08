class AddCounterCacheToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :sessions_count, :integer
  end
end

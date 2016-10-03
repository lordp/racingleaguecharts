class MigrateDriverUsersToDrivers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      DriverUser.where(:user_id => user.id).each do |driver_user|
        if driver_user.driver
          driver_user.driver.update(:user_id => user.id)
        end
      end
    end
  end

  def down
    Driver.all.each do |driver|
      driver.update(:user_id => nil)
    end
  end
end

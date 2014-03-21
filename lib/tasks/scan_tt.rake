namespace :scan do

  desc "Scan Time Trial Threads"
  task :tt => :environment do
    Race.where(:time_trial => true).where('thing != ?', nil).each(&:scan_time_trial)
  end
end

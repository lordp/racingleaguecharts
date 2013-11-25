module ApplicationHelper

  def nice_time(time)
    return '?' if time.nil?
    nice = ""
    nice = "#{time.floor / 60}:" if time > 60
    "#{nice}#{number_with_precision(time % 60, :precision => 3)}"
  end

  def find_best_times(laps)
    
    return laps
  end

end

module ApplicationHelper

  def nice_time(time)
    return '?' if time.nil?
    nice = ""
    nice = "#{time.floor / 60}:" if time > 60
    mod = time % 60
    "#{nice}#{mod < 10 ? '0' : ''}#{number_with_precision(mod, :precision => 3)}"
  end

  def find_best_times(laps)
    return laps
  end

  def is_current?(obj, at_obj)
    "glyphicon-ok" if obj == at_obj
  end

  def bootstrap_alert(name)
    case name
    when :notice
      "alert alert-success"
    end
  end

end

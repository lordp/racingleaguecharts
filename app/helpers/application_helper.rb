module ApplicationHelper

  def nice_time(time)
    return '?' if time.nil?
    nice = ""
    nice = "#{time.floor / 60}:" if time > 60
    mod = time % 60
    "#{nice}#{mod < 10 ? '0' : ''}#{number_with_precision(mod, :precision => 3)}"
  end

  def is_current?(obj, at_obj)
    "glyphicon-ok" if obj == at_obj
  end

  def bootstrap_alert(name)
    case name
      when :notice
        "alert alert-success"
      else
        nil
    end
  end

  def breadcrumb(obj, leaf = false)
    case obj
      when Session
        breadcrumb(obj.race) + content_tag('li', breadcrumb_link(obj, leaf), :class => (leaf ? 'active' : ''))
      when Race
        breadcrumb(obj.season) + content_tag('li', breadcrumb_link(obj, leaf))
      when Season
        breadcrumb(obj.league) + content_tag('li', breadcrumb_link(obj, leaf))
      when League
        breadcrumb(obj.super_league) + content_tag('li', breadcrumb_link(obj, leaf))
      when SuperLeague
        content_tag('li', obj.name)
      else
        nil
    end
  end

  def breadcrumb_link(obj, leaf)
    case obj
      when Session
        obj.name
      when Race
        leaf ? obj.name : link_to(obj.name, race_path(obj))
      when Season
        leaf ? obj.name : link_to(obj.name, season_path(obj))
      when League
        leaf ? obj.name : link_to(obj.name, league_path(obj))
      when SuperLeague
        leaf ? obj.name : link_to(obj.name, super_league_path(obj))
      else
        nil
    end
  end

end

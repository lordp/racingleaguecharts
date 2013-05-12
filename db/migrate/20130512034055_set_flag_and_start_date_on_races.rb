class SetFlagAndStartDateOnRaces < ActiveRecord::Migration
  def up
    races = {
      "AUS" => { flag: "australia", start_date: "2013-03-16 00:00:00" },
      "MAL" => { flag: "malaysia", start_date: "2013-03-23 00:00:00" },
      "CHN" => { flag: "china", start_date: "2013-04-13 00:00:00" },
      "BAH" => { flag: "bahrain", start_date: "2013-04-20 00:00:00" },
      "ESP" => { flag: "spain", start_date: "2013-05-11 00:00:00" },
      "MON" => { flag: "monaco", start_date: "2013-05-25 00:00:00" },
      "CAN" => { flag: "canada", start_date: "2013-06-08 00:00:00" },
      "GBR" => { flag: "uk", start_date: "2013-06-29 00:00:00" },
      "GER" => { flag: "germany", start_date: "2013-07-08 00:00:00" },
      "HUN" => { flag: "hungary", start_date: "2013-07-27 00:00:00" },
      "BEL" => { flag: "belgium", start_date: "2013-08-24 00:00:00" },
      "ITA" => { flag: "italy", start_date: "2013-09-07 00:00:00" },
      "SIN" => { flag: "singapore", start_date: "2013-09-21 00:00:00" },
      "KOR" => { flag: "korea", start_date: "2013-10-05 00:00:00" },
      "JPN" => { flag: "japan", start_date: "2013-10-12 00:00:00" },
      "IND" => { flag: "india", start_date: "2013-10-26 00:00:00" },
      "UAE" => { flag: "abu-dhabi", start_date: "2013-11-02 00:00:00" },
      "USA" => { flag: "us", start_date: "2013-11-16 00:00:00" },
      "BRA" => { flag: "brazil", start_date: "2013-11-23 00:00:00" },
    }

    races.each do |short_name, details|
      Race.where(:short_name => short_name).each do |race|
        race.update_attributes(details)
      end
    end
  end

  def down
  end
end

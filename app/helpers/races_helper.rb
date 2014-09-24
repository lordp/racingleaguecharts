module RacesHelper
  def cache_key_for_races
    count          = Race.count
    max_updated_at = Race.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "races/all-#{count}-#{max_updated_at}"
  end
end

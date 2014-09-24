module SuperLeaguesHelper
  def cache_key_for_super_leagues
    count          = SuperLeague.count
    max_updated_at = SuperLeague.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "super_leagues/all-#{count}-#{max_updated_at}"
  end
end

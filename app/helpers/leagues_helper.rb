module LeaguesHelper
  def cache_key_for_leagues
    count          = League.count
    max_updated_at = League.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "leagues/all-#{count}-#{max_updated_at}"
  end
end

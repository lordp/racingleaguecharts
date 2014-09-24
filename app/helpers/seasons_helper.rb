module SeasonsHelper
  def cache_key_for_seasons
    count          = Season.count
    max_updated_at = Season.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "seasons/all-#{count}-#{max_updated_at}"
  end
end

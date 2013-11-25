module Enumerable

  def mean
    sum / length.to_f
  end

  def sample_variance
    sum = inject(0) { |accum, i| accum + (i - mean) ** 2 }
    sum / (length - 1).to_f
  end

  def standard_deviation
    Math.sqrt(sample_variance)
  end

end
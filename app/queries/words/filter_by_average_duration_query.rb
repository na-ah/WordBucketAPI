class Words::FilterByAverageDurationQuery
  def self.call(words, params, type: :relation)
    average_duration_min = params[:average_duration_min] || nil
    average_duration_max = params[:average_duration_max] || nil

    words = words.select('ROUND(CAST(AVG(histories.duration) AS numeric), 2) as average_duration').group('words.id')

    words = words.having('AVG(histories.duration) >= ?', average_duration_min) if average_duration_min

    words = words.having('AVG(histories.duration) < ?', average_duration_max) if average_duration_max

    type === :relation ? words : words.size.count
  end
end

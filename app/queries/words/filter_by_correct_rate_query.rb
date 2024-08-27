class Words::FilterByCorrectRateQuery
  def self.call(words, params, type: :relation)
    correct_rate_max = params[:correct_rate_max] || nil
    correct_rate_min = params[:correct_rate_min] || nil

    words = words
                .select('ROUND(AVG(CASE histories.result WHEN true THEN 1 WHEN false THEN 0 END), 2) as correct_rate')
                .group('words.id')

    words = words.having('AVG(CASE histories.result WHEN true THEN 1 WHEN false THEN 0 END) >= ?', correct_rate_min) if correct_rate_min

    words = words.having('AVG(CASE histories.result WHEN true THEN 1 WHEN false THEN 0 END) < ?', correct_rate_max) if  correct_rate_max

    type === :relation ? words : words.size.count
  end
end

class Words::FilterByCountQuery
  def self.call(words, params, type: :relation)
    learning_count_min = params[:learning_count_min] || nil
    learning_count_max = params[:learning_count_max] || nil

    words = words
                .select('words.id, words.word, COUNT(histories.id) as learning_count')
                .left_joins(:histories)
                .group('words.id')

    words = words.having('COUNT(histories.id) >= ?', learning_count_min) if learning_count_min

    words = words.having('COUNT(histories.id) < ?', learning_count_max) if learning_count_max

    type === :relation ? words : words.size.count

  end
end

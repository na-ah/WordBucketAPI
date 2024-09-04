class Words::FilterByMissingQuery
  def self.call(words, params, type: :relation)
    missing_examples = params[:missing_examples] || nil
    missing_meanings = params[:missing_meanings] || nil
    words = words
              .select("words.id, words.word, COUNT(meanings.id) as Meanings_count, COUNT(examples.id) as Examples_count")
              .left_joins(:meanings, :examples)
              .group("words.id")

    words = words.having("COUNT(meanings.id) = 0") if missing_meanings
    words = words.having("COUNT(examples.id) = 0") if missing_examples

    type === :relation ? words : words.size.count
  end
end

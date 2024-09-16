class Words::WordsForListQuery
  def self.call(words)
    for_status_words = Word.includes(:meanings, :examples, :histories)
    unlearned_word_ids = Words::FilterByStatusQuery.call(for_status_words, { status: :unlearned }).pluck(:id)
    in_progress_word_ids = Words::FilterByStatusQuery.call(for_status_words, { status: :in_progress }).pluck(:id)
    memorizing_word_ids = Words::FilterByStatusQuery.call(for_status_words, { status: :memorizing }).pluck(:id)

    words = Word
      .select('
        words.id,
        words.word,
        ROUND(CAST(AVG(histories.duration) AS numeric),2) as average_duration,
        ROUND(AVG(CASE histories.result WHEN true THEN 1 WHEN false THEN 0 END), 2) AS correct_rate,
        COUNT(histories) AS learning_count
              ')
      .includes(:examples, :meanings, :histories)
      .where(word: words)
      .group("words.id")
      .left_joins(:histories)

    word_hash = Hash.new { |hash, key| hash[key] = {} }
    words.each do |word|
      status = if unlearned_word_ids.include?(word.id)
        "unlearned"
      elsif in_progress_word_ids.include?(word.id)
        "in_progress"
      elsif memorizing_word_ids.include?(word.id)
        "memorizing"
      end
      word_hash[word[:word]] = word.as_json.merge({
        status: status,
        meanings: word.meanings.as_json,
        examples: word.examples.as_json,
        histories: word.histories.as_json
      })
    end
    word_hash
  end
end

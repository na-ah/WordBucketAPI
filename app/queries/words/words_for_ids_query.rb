class Words::WordsForIdsQuery
  def self.call(ids)
    words = Word
      .select('
        words.id,
        words.word,
        ROUND(CAST(AVG(histories.duration) AS numeric),2) as average_duration,
        ROUND(AVG(CASE histories.result WHEN true THEN 1 WHEN false THEN 0 END), 2) AS correct_rate,
        COUNT(histories) AS learning_count
              ')
      .includes(:examples, :meanings, :histories)
      .where(id: ids)
      .group("words.id")
      .left_joins(:histories)
    words = words.map do |word|
      word.as_json.merge({
        meanings: word.meanings.as_json,
        examples: word.examples.as_json,
        histories: word.histories.as_json
      })
    end
    words
  end
end

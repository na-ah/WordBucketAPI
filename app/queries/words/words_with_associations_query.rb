class Words::WordsWithAssociationsQuery
  def self.call(words)
    results = []
    words
    .includes(:meanings, :examples, :histories)
    .order("RANDOM()")
    .each do |word|
      results << word.as_json.merge({
        meanings: word.meanings.as_json,
        examples: word.examples.as_json,
        histories: word.histories.as_json
      })
    end
    results
  end
end

class Words::WordsForDashboardQuery
  def self.call(words)
    words.pluck(:id)
  end
end

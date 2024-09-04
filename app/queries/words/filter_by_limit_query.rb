class Words::FilterByLimitQuery
  def self.call(words, params, type: :relation)
    limit = params[:limit].to_i || null
    words = words.limit(limit)
    type === :relation ? words : words.size.count
  end
end

class Words::FilterByHistoryDateQuery
  def self.call(words, params, type: :relation)
    if params[:sort_by_latest_history]
      order = "DESC"
    elsif params[:sort_by_oldest_history]
      order = "ASC"
    end

    if order
      words = words
          .includes(:histories)
          .where.not(histories: { id: nil })
          .group("words.id")
          .order("MAX(histories.datetime) #{order}")
    end

    type === :relation ? words : words.size.count
  end
end

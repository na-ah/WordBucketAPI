class Words::FilterByDateQuery
  def self.call(words, params)
    created_at_from = params[:created_at_from] || nil
    created_at_to = params[:created_at_to] || nil

    created_at_to = created_at_to&.to_date&.end_of_day ||= Time.current.end_of_day

    words = words.where('words.created_at >= ?',  created_at_from) if created_at_from.present?
    words = words.where('words.created_at <= ?', created_at_to) if created_at_to.present?
    words
  end
end

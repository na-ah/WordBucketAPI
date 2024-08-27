class Words::FilterByStatusQuery
  def self.call(words, params, type: :relation)
    status = params[:status]&.to_sym || nil

    words = words.group('words.id')

    case status
    when :unlearned
      words = words.having('COUNT(histories.id) = 0')
    when :in_progress
      in_progress_word_ids =
        History
          .select(:word_id)
          .from("(
            SELECT
              word_id,
              result,
              ROW_NUMBER() OVER (
                PARTITION BY word_id
                ORDER BY created_at DESC) AS row_num
            FROM histories)")
          .where('row_num <= 3')
          .group(:word_id)
          .having('SUM(CASE WHEN result = true THEN 1 ELSE 0 END) <> 3')

      words = words.where(id: in_progress_word_ids)
    when :completed
      completed_word_ids =
        History
          .select(:word_id)
          .from("(
            SELECT
              word_id,
              result,
              ROW_NUMBER() OVER (
                PARTITION BY word_id
                ORDER BY created_at DESC) AS row_num
            FROM histories)")
          .where('row_num <= 3')
          .group(:word_id)
          .having('COUNT(*) = 3')
          .having('SUM(CASE WHEN result = true THEN 1 ELSE 0 END) = 3')

      words = words.where(id: completed_word_ids)
    end

    type === :relation ? words : words.count.size
  end
end

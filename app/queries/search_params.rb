class SearchParams
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def filter_words(words)
    words = filter_by_date(words)
    words = filter_by_count(words)
    # words = filter_by_rate(words)
    # words = filter_by_duration(words)
    # words = filter_by_status(words)
    words
  end

  private

  def filter_by_date(words)
    if params[:created_at_from].present? || params[:created_at_to].present?
      created_at_from = params[:created_at_from].presence
      created_at_to = params[:created_at_to].presence&.to_date&.end_of_day || Time.current.end_of_day

      words = words.where('created_at >= ?',  created_at_from) if created_at_from.present?
      words = words.where('created_at <= ?', created_at_to)
    end

    words
  end

  def filter_by_count(words)
    if params[:learning_count_from].present? || params[:learning_count_to].present?
      learning_count_from = params[:learning_count_from].presence || 0
      learning_count_to = params[:learning_count_to].presence

      # words = words
      #             .select('words.id, words.word, COUNT(histories.id) as learning_count')
      #             .left_joins(:histories)
      #             .group('words.id')
      #             .having('COUNT(histories.id) >= ?', learning_count_from)
      # words = words
      #             .having('COUNT(histories.id) <= ?', learning_count_to) if learning_count_to

      words = words.find_by_sql([<<-SQL, learning_count_from])
        SELECT words.id, words.word, COUNT(histories.id) AS learning_count, words.created_at
        FROM words
        LEFT JOIN histories
        ON words.id = histories.word_id
        GROUP BY words.id
        HAVING COUNT(histories.id) >= ?
      SQL
    end

    words
  end

  # def filter_by_rate(words)
  #   words
  # end

  def filter_by_status(words)
    if params[:status].present?
      case params[:status].to_sym
      when :unlearned
        words = words
                    .left_joins(:histories)
                    .group('words.id')
                    .having('COUNT(histories.id) = 0')

        # word_ids = words.find_by_sql(<<-SQL)
        #   SELECT words.id, words.word, COUNT(histories.id)
        #   FROM words
        #   LEFT JOIN histories
        #   ON words.id = histories.word_id
        #   GROUP BY words.id
        #   HAVING count(histories.id) = 0
        # SQL
      when :in_progress
        word_ids = words.find_by_sql(<<-SQL)
          SELECT words.id, words.word, COUNT(histories.id)
          FROM words
          LEFT JOIN histories
          ON words.id = histories.word_id
          GROUP BY words.id
          HAVING COUNT(histories.id) > 0
        SQL
          # .left_joins(:histories)
          # .group('words.id')
          # .having('COUNT(histories.id) > 0')
      when :completed, :memorizing
        word_ids = Word.find_by_sql(<<-SQL)
          SELECT words.*
          FROM words
          WHERE words.id IN (
            SELECT word_id
            FROM (
              SELECT
                word_id,
                result,
                ROW_NUMBER() OVER (PARTITION BY word_id ORDER BY created_at DESC) as latest_number
              FROM histories
            ) as ordered_histories
            WHERE latest_number <= 3
            GROUP BY word_id
            HAVING COUNT(*) = 3 AND SUM(CASE WHEN result = true THEN 1 ELSE 0 END) = 3
          )
        SQL

        # 以下は遅いSQL
        # words = Word.find_by_sql(<<-SQL)
        #   SELECT words.*
        #   FROM words
        #   WHERE words.id IN (
        #     SELECT word_id
        #     FROM histories AS h1
        #     WHERE (
        #       SELECT COUNT(*)
        #       FROM histories AS h2
        #       WHERE h2.word_id = h1.word_id AND h2.created_at >= h1.created_at
        #     ) <= 3
        #     GROUP BY word_id
        #     HAVING COUNT(*) = 3 AND SUM(CASE WHEN result = true THEN 1 ELSE 0 END) = 3
        #   )
        # SQL
      end
      word_ids ||= []
      words = word_ids.any? ?  words.where(id: word_ids) : words
    end
    words
  end
end

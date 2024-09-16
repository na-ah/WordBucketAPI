class WordsController < ApplicationController
  def index
    words = Word.includes(:meanings, :examples, :histories).map do |word|
      word.as_json.merge({
        meanings: word.meanings.as_json,
        examples: word.examples.as_json,
        histories: word.histories.as_json
      })
    end

    render json: { words: words }, status: 200
  end

  def show
    word = Word.find_by(id: params[:id])
    p word.examples
    if word
      word_json = word.as_json
      word_json[:meanings] = word.meanings.map(&:as_json)
      word_json[:examples] = word.examples.map(&:as_json)
      word_json[:histories] = word.histories.map(&:as_json)
      render json: { word: word_json }, status: 200
    else
      render json: { error: "Word not found" }, status: 404
    end
  end

  def create
    word = Word.find_or_create_by(word_params)

    if params[:meaning]
      word.meanings.find_or_initialize_by(meaning_params)
    end

    if params[:example]
      word.examples.find_or_initialize_by(example_params)
    end

    if params[:history]
      word.histories.find_or_initialize_by(history_params)
    end

    if word.save
      render json: { data: word.as_json(include: [ :meanings, :examples, :histories ]) }, status: 200
    else
      render json: { errors: word.errors }, status: 400
    end
  end

  def update
    word = Word.find_by(id: params[:id])

    unless word
      render json: { message: "Word not found" }, status: 404
    end

    ActiveRecord::Base.transaction do
      if params[:meaning].present?
        word.meanings.find_or_create_by(meaning: meaning_params[:meaning])
      end

      if params[:example].present?
        word.examples.find_or_create_by(example: example_params[:example])
      end

      if word.update(word_params)
        word_json = word.as_json.merge({
            meanings: word.meanings.as_json,
            examples: word.examples.as_json,
            histories: word.histories.as_json
          })
        render json: { word: word_json }, status: 200
      else
        render json: { errors: word.errors }, status: 400
      end
    end
  end

  def destroy
    word = Word.find_by(id: params[:id])

    if word
      word.destroy
      render json: { message: "Word deleted successfully" }, status: 200
    else
      render json: { error: "Word not found" }, status: 404
    end
  end

  def search
    words = Word.includes(:meanings, :examples, :histories)
    # words = Word.all
    words = filter_words(words)

    words_json = Words::WordsWithAssociationsQuery.call(words)

    render json: { words: words_json }, status: 200
  end

  def ids
    ids = ids_params[:ids].split(",").map(&:to_i)
    words = Words::WordsForIdsQuery.call(ids)
    render json: { words: words }, status: 200
  end

  def list
    words = words_params[:words].split(",")
    words = Words::WordsForListQuery.call(words)
    render json: words.as_json, status: 200
  end

  private

  def filter_words(words)
    words = Words::FilterByCountQuery.call(
      words,
      search_learning_count_params
    )
    words = Words::FilterByStatusQuery.call(
      words,
      search_status_params
    )
    words = Words::FilterByCorrectRateQuery.call(
      words,
      search_correct_rate_params
    )
    words = Words::FilterByDateQuery.call(
      words,
      search_date_params
    )
    words = Words::FilterByAverageDurationQuery.call(
      words,
      search_average_duration_params
    )
    words = Words::FilterByMissingQuery.call(
      words,
      search_missing_params
    )
    words = Words::FilterByLimitQuery.call(
      words,
      search_limit_params
    )

    words = Words::FilterByHistoryDateQuery.call(
      words,
      search_history_date_params
    )
    words
  end

  # クエリで使用するパラメータ
  def search_history_date_params
    params.slice(:sort_by_latest_history, :sort_by_oldest_history).permit(:sort_by_latest_history, :sort_by_oldest_history)
  end

  def search_limit_params
    params.slice(:limit).permit(:limit)
  end

  def search_missing_params
    params.slice(:missing_examples, :missing_meanings).permit(:missing_examples, :missing_meanings)
  end

  def search_learning_count_params
    params.slice(:learning_count_min, :learning_count_max).permit(:learning_count_min, :learning_count_max)
  end

  def search_date_params
    params.slice(:created_at_from, :created_at_to).permit(:created_at_from, :created_at_to)
  end

  def search_correct_rate_params
    params.slice(:correct_rate_min, :correct_rate_max).permit(:correct_rate_min, :correct_rate_max)
  end

  def search_average_duration_params
    params.slice(:average_duration_min, :average_duration_max).permit(:average_duration_min, :average_duration_max)
  end

  def search_status_params
    params.slice(:status).permit(:status)
  end


  # クエリ以外で使用するパラメータ
  def word_params
    params.permit(:word)
  end

  def example_params
    params.permit(:example)
  end

  def meaning_params
    params.permit(:meaning)
  end

  def history_params
    params.require(:history).permit(:duration, :result, :datetime)
  end

  def status_params
    params.permit(:status)
  end

  def ids_params
    params.slice(:ids).permit(:ids)
  end

  def words_params
    params.slice(:words).permit(:words)
  end
end

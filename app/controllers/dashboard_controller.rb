class DashboardController < ApplicationController
  def index
    words = Word.includes(:meanings, :examples, :histories)

    # top
    new_cards = words.where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day).count
    today_learning_cards = words.joins(:histories).where(histories: { datetime: Time.zone.today.all_day }).count

    # missing
    missing_meanings = Words::FilterByMissingQuery.call(words, { missing_meanings: true }, type: :count)
    missing_examples = Words::FilterByMissingQuery.call(words, { missing_examples: true }, type: :count)
    missing_meanings_and_examples = Words::FilterByMissingQuery.call(words, { missing_meanings: true, missing_examples: true }, type: :count)

    # learning
    unlearned = Words::FilterByStatusQuery.call(words, { status: "unlearned" }, type: :count)
    in_progress = Words::FilterByStatusQuery.call(words, { status: "in_progress" }, type: :count)
    completed = Words::FilterByStatusQuery.call(words, { status: "completed" }, type: :count)
    completedWords = Words::FilterByStatusQuery.call(words, { status: "completed" })

    # memorizing::学習回数
    low_count = Words::FilterByCountQuery.call(completedWords, { learning_count_max: 5 }, type: :count)
    medium_count =  Words::FilterByCountQuery.call(completedWords, { learning_count_min: 5, learning_count_max: 10 }, type: :count)
    high_count = Words::FilterByCountQuery.call(completedWords, { learning_count_min: 10 }, type: :count)

    # memorizing::正答率
    low_accuracy_rate = Words::FilterByCorrectRateQuery.call(completedWords, { correct_rate_max: 0.2 }, type: :count)
    medium_accuracy_rate = Words::FilterByCorrectRateQuery.call(completedWords, { correct_rate_min: 0.2, correct_rate_max: 0.5 }, type: :count)
    high_accuracy_rate = Words::FilterByCorrectRateQuery.call(completedWords, { correct_rate_min: 0.5 }, type: :count)

    # memorizing::所要時間
    short_duration = Words::FilterByAverageDurationQuery.call(completedWords, { average_duration_max: 2 }, type: :count)
    medium_duration = Words::FilterByAverageDurationQuery.call(completedWords, { average_duration_min: 2, average_duration_max: 5 }, type: :count)
    long_duration = Words::FilterByAverageDurationQuery.call(completedWords, { average_duration_min: 5 }, type: :count)

    render json: {
      new_cards: new_cards,
      today_learning_cards: today_learning_cards,
      missing_meanings: missing_meanings,
      missing_examples: missing_examples,
      missing_meanings_and_examples: missing_meanings_and_examples,
      unlearned: unlearned,
      in_progress: in_progress,
      completed: completed,
      low_count: low_count,
      medium_count: medium_count,
      high_count: high_count,
      low_accuracy_rate: low_accuracy_rate,
      medium_accuracy_rate: medium_accuracy_rate,
      high_accuracy_rate: high_accuracy_rate,
      short_duration: short_duration,
      medium_duration: medium_duration,
      long_duration: long_duration
    }, status: 200
  end
end

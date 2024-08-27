class DashboardController < ApplicationController
  def index
    # words = Word.eager_load(:meanings, :examples, :histories)
    words = Word.left_outer_joins(:meanings, :examples, :histories)

    # top
    new_cards = words.where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day).count
    today_learning_cards = words.joins(:histories).where(histories: { datetime: Time.zone.today.all_day }).count

    # learning
    unlearned = Words::FilterByStatusQuery.call(words, {status: 'unlearned'}, type: :count)
    in_progress = Words::FilterByStatusQuery.call(words, {status: 'in_progress'}, type: :count)
    completed = Words::FilterByStatusQuery.call(words, {status: 'completed'}, type: :count)

    # memorizing::学習回数
    under_four = Words::FilterByCountQuery.call(words, {learning_count_max: 4}, type: :count)
    five_to_nine =  Words::FilterByCountQuery.call(words, {learning_count_min: 5, learning_count_max: 9}, type: :count)
    over_ten = Words::FilterByCountQuery.call(words, {learning_count_min: 10}, type: :count)

    # memorizing::正答率
    low_accuracy_rate = Words::FilterByCorrectRateQuery.call(words, {correct_rate_max: 0.2}, type: :count)
    medium_accuracy_rate = Words::FilterByCorrectRateQuery.call(words, {correct_rate_min: 0.2, correct_rate_max: 0.5}, type: :count)
    high_accuracy_rate = Words::FilterByCorrectRateQuery.call(words, {correct_rate_min: 0.5}, type: :count)

    # memorizing::所要時間
    shortDuration = Words::FilterByAverageDurationQuery.call(words, {average_duration_max: 2}, type: :count)
    mediumDuration = Words::FilterByAverageDurationQuery.call(words, {average_duration_min: 2, average_duration_max: 5}, type: :count)
    longDuration = Words::FilterByAverageDurationQuery.call(words, {average_duration_min: 5}, type: :count)

    render json: {
      new_cards: new_cards,
      today_learning_cards: today_learning_cards,
      unlearned: unlearned,
      in_progress: in_progress,
      completed: completed,
      under_four: under_four,
      five_to_nine: five_to_nine,
      over_ten: over_ten,
      low_accuracy_rate: low_accuracy_rate,
      medium_accuracy_rate: medium_accuracy_rate,
      high_accuracy_rate: high_accuracy_rate,
      shortDuration: shortDuration,
      mediumDuration: mediumDuration,
      longDuration: longDuration
    }, status: 200
  end
end

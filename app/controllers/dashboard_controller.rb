class DashboardController < ApplicationController
  def index
    # words = Word.eager_load(:meanings, :examples, :histories)
    words = Word.left_outer_joins(:meanings, :examples, :histories)

    # top
    new_cards = words.where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day).count
    today_learning_cards = words.joins(:histories).where(histories: { datetime: Time.zone.today.all_day }).count

    # learning
    unlearned = Words::FilterByStatusQuery.call(words, {status: 'unlearned'})
    in_progress = Words::FilterByStatusQuery.call(words, {status: 'in_progress'})
    completed = Words::FilterByStatusQuery.call(words, {status: 'completed'})

    # memorizing::学習回数
    under_four = Words::FilterByCountQuery.call(words, {learning_count_max: 4})
    five_to_nine =  Words::FilterByCountQuery.call(words, {learning_count_min: 5, learning_count_max: 9})
    over_ten = Words::FilterByCountQuery.call(words, {learning_count_min: 10})


    render json: {
      new_cards: new_cards,
      today_learning_cards: today_learning_cards,
      unlearned: unlearned,
      in_progress: in_progress,
      completed: completed,
      under_four: under_four,
      five_to_nine: five_to_nine,
      over_ten: over_ten,
    }, status: 200
  end
end

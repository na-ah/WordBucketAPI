# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
  10000.times do
    word = Word.create!(
      word: Faker::Hipster.words(number: 1).first
    )

    rand(0..3).times do
      word.meanings.create!(
        meaning: Faker::Lorem.sentence(word_count: 3)
      )
    end

    rand(0..5).times do
      word.examples.create!(
        example: Faker::Lorem.sentence(word_count: 3) + " #{word.word} " + Faker::Lorem.sentence(word_count: 4)
      )
    end

    rand(0..30).times do
      start_time = Time.zone.local(2024, 1, 1)
      end_time = Time.zone.today.end_of_day
      random_time = start_time + rand(end_time.to_i - start_time.to_i).seconds

      word.histories.create!(
        duration: rand(0.5..10.0).round(2),
        result: [true, false].sample,
        datetime: random_time
      )
    end
  end

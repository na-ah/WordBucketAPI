class AddWordToMeanings < ActiveRecord::Migration[7.2]
  def change
    add_reference :meanings, :word, null: false, foreign_key: true
  end
end

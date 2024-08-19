class CreateHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :histories do |t|
      t.datetime :datetime, null: false
      t.boolean :result, null: false
      t.float :duration, null: false
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateExamples < ActiveRecord::Migration[7.2]
  def change
    create_table :examples do |t|
      t.string :example, null: false
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end

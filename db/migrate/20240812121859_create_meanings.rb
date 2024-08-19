class CreateMeanings < ActiveRecord::Migration[7.2]
  def change
    create_table :meanings do |t|
      t.string :meaning, null: false

      t.timestamps
    end
  end
end

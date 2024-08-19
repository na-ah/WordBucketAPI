class ChangeColumnsNotnullAddWords < ActiveRecord::Migration[7.2]
  def change
    change_column_null :words, :word, false
  end
end

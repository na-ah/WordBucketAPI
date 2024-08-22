# == Schema Information
#
# Table name: examples
#
#  id         :bigint           not null, primary key
#  example    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  word_id    :bigint           not null
#
# Indexes
#
#  index_examples_on_word_id  (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
class Example < ApplicationRecord
  belongs_to :word

  validates :example, presence: true, uniqueness: { scope: :word_id }
end

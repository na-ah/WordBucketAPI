# == Schema Information
#
# Table name: meanings
#
#  id         :bigint           not null, primary key
#  meaning    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  word_id    :bigint           not null
#
# Indexes
#
#  index_meanings_on_word_id  (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
class Meaning < ApplicationRecord
  belongs_to :word

  validates :meaning, presence: true, uniqueness: { scope: :word_id }
end

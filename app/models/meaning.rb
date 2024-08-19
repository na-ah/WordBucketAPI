class Meaning < ApplicationRecord
  belongs_to :word

  validates :meaning, presence: true, uniqueness: { scope: :word_id }
end

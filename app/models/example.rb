class Example < ApplicationRecord
  belongs_to :word

  validates :example, presence: true, uniqueness: { scope: :word_id }
end

class Word < ApplicationRecord
  has_many :meanings, dependent: :destroy
  has_many :examples, dependent: :destroy
  has_many :histories, dependent: :destroy

  validates :word, presence: true
end

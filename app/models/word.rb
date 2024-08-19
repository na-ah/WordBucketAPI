class Word < ApplicationRecord
  has_many :meanings, dependent: :destroy
  has_many :examples
  has_many :histories

  validates :word, presence: true
end

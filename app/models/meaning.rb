class Meaning < ApplicationRecord
  belongs_to :word

  validates :meaning, presence: true
end

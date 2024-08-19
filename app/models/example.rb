class Example < ApplicationRecord
  belongs_to :word

  validates :example, presence: true
end

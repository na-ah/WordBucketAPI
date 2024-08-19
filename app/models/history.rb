class History < ApplicationRecord
  belongs_to :word

  validates :datetime, presence: true
  validates :result, inclusion: { in: [ true, false ] }
  validates :duration, presence: true
end

# == Schema Information
#
# Table name: words
#
#  id         :bigint           not null, primary key
#  word       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Word < ApplicationRecord
  has_many :meanings, dependent: :destroy
  has_many :examples, dependent: :destroy
  has_many :histories, dependent: :destroy

  validates :word, presence: true
end

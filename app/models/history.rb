# == Schema Information
#
# Table name: histories
#
#  id         :bigint           not null, primary key
#  datetime   :datetime         not null
#  duration   :float            not null
#  result     :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  word_id    :bigint           not null
#
# Indexes
#
#  index_histories_on_word_id  (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
class History < ApplicationRecord
  belongs_to :word

  validates :datetime, presence: true
  validates :result, inclusion: { in: [ true, false ] }
  validates :duration, presence: true
end

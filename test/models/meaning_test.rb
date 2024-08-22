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
require "test_helper"

class MeaningTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

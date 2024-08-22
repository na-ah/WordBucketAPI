# == Schema Information
#
# Table name: examples
#
#  id         :bigint           not null, primary key
#  example    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  word_id    :bigint           not null
#
# Indexes
#
#  index_examples_on_word_id  (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
require "test_helper"

class ExampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

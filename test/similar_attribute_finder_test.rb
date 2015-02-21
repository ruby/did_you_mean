require_relative 'test_helper'

class SimilarAttributeFinderTest < Minitest::Test
  def setup
    error_class = if defined?(ActiveModel::AttributeAssignment::UnknownAttributeError)
      ActiveModel::AttributeAssignment::UnknownAttributeError
    else
      ActiveRecord::UnknownAttributeError
    end

    @error = assert_raises(error_class) do
      User.new(flrst_name: "wrong flrst name")
    end
  end

  def test_similar_words
    assert_suggestion @error.suggestions, "first_name"
  end

  def test_did_you_mean?
    assert_match "Did you mean? first_name: string", @error.did_you_mean?
  end
end

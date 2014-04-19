require_relative 'test_helper'

class SimilarAttributeFinderTest < Test::Unit::TestCase
  def setup
    @error = assert_raise(ActiveRecord::UnknownAttributeError) do
      User.new(flrst_name: "wrong flrst name")
    end
  end

  def test_similar_columns
    assert @error.method_finder.similar_columns.include?("first_name")
  end

  def test_did_you_mean?
    assert_match "Did you mean? first_name", @error.did_you_mean?
  end

  def test_message
    assert_match @error.did_you_mean?, @error.message
  end
end

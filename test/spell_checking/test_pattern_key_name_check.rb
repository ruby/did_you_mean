require_relative '../helper'

eval("\n#{<<~'END_of_GUARD'}", binding, __FILE__, __LINE__) if defined?(::NoMatchingPatternKeyError)
class PatternKeyNameCheckTest < Test::Unit::TestCase
  include DidYouMean::TestHelper

  def test_corrects_hash_key_name_with_single_pattern_match
    hash = {foo: 1, bar: 2, baz: 3}

    error = assert_raise(NoMatchingPatternKeyError) do
      hash => {fooo:}
      raise fooo # suppress "unused variable: fooo" warning
    end
    assert_correction ":foo", error.corrections
    assert_match "Did you mean?  :foo", error.to_s
  end
end
END_of_GUARD

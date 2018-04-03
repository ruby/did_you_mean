require 'test_helper'

class DeprecatedFormatterTest < Minitest::Test
  def test_deprecated_formatter
    assert_output nil, /test\/deprecated_formatter_test.rb:6: warning: constant DidYouMean::Formatter is deprecated/ do
      assert_equal "\nDid you mean?  does_exist", ::DidYouMean::Formatter.new(['does_exist']).to_s
    end
  end
end

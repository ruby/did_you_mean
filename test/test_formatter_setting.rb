require_relative './helper'

class FormatterSettingTest < Test::Unit::TestCase
  include DidYouMean::TestHelper

  class CustomFormatter
    def self.message_for(corrections)
      "\nCustom: #{corrections.join(", ")}"
    end
  end

  def setup
    @original_formatter = DidYouMean.formatter
  end

  def teardown
    DidYouMean.formatter = @original_formatter
  end

  def test_formatter_defaults_to_formatter
    DidYouMean.formatter = nil

    assert_equal DidYouMean::Formatter, DidYouMean.formatter
  end

  def test_formatter_can_be_replaced
    DidYouMean.formatter = CustomFormatter

    assert_equal CustomFormatter, DidYouMean.formatter
  end

  def test_replaced_formatter_is_used_for_messages
    DidYouMean.formatter = CustomFormatter

    error = assert_raise(NoMethodError) { "".lenght }

    assert_match "Custom: length", get_message(error)
  end
end

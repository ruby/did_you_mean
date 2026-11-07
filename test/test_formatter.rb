require_relative './helper'
require 'open3'

class FormatterTest < Test::Unit::TestCase
  class CustomFormatter
    def self.message_for(corrections)
      " custom suggestions: #{corrections.join(', ')}"
    end
  end

  def setup
    @original_formatter = DidYouMean.formatter
  end

  def teardown
    DidYouMean.formatter = @original_formatter
  end

  def test_default_formatter_does_not_warn_in_a_fresh_process
    stdout, stderr, status = Open3.capture3(
      RbConfig.ruby, '--disable-did_you_mean', '-w',
      '-I', File.expand_path('../lib', __dir__),
      '-rdid_you_mean', '-e', 'puts DidYouMean.formatter'
    )

    assert_predicate status, :success?
    assert_equal "DidYouMean::Formatter\n", stdout
    assert_equal '', stderr
  end

  def test_custom_formatter_is_used_for_error_messages
    DidYouMean.formatter = CustomFormatter
    assert_same CustomFormatter, DidYouMean.formatter
    error = assert_raise(KeyError) { { book: 1 }.fetch(:boook) }
    assert_include DidYouMean::TestHelper.get_message(error), 'custom suggestions: :book'
  end

  def test_nil_formatter_restores_default
    DidYouMean.formatter = CustomFormatter
    DidYouMean.formatter = nil
    assert_same DidYouMean::Formatter, DidYouMean.formatter
  end

  unless defined?(Ractor)
    def test_formatter_is_shared_between_threads_without_ractors
      DidYouMean.formatter = CustomFormatter
      assert_same CustomFormatter, Thread.new { DidYouMean.formatter }.value
    end
  end
end

require_relative 'test_helper'

class NameErrorExtensionTest < Minitest::Test
  class TestFinder
    def initialize(*); end
    def did_you_mean?; "Y U SO SLOW?"; end
  end

  def setup
    @old_finder = DidYouMean.finders["NameError"]
    DidYouMean.finders["NameError"] = TestFinder

    @error = assert_raises(NameError){ doesnt_exist }
  end

  def teardown
    DidYouMean.finders["NameError"] = @old_finder
  end

  def test_message?
    assert_match "Y U SO SLOW?", @error.to_s
    assert_match "Y U SO SLOW?", @error.message
  end

  def test_whitelisted_message?
    @error = safe_constantize
    assert @error.to_s =~ /doesnt_exist/
    assert @error.message =~ /doesnt_exist/
  end

  def test_note_whitelisted_message?
    @error = not_safe_constantize
    assert_match "Y U SO SLOW?", @error.to_s
    assert_match "Y U SO SLOW?", @error.message
  end

  private

  def safe_constantize
    assert_raises(NAME_ERROR){ doesnt_exist }
  end

  def not_safe_constantize
    assert_raises(NAME_ERROR){ doesnt_exist }
  end
end

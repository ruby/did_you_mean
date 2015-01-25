require_relative 'test_helper'

class NameErrorExtensionTest < Minitest::Test
  class TestFinder
    def initialize(*); end
    def did_you_mean?; "Y U SO SLOW?"; end
  end

  def setup
    @org = DidYouMean.finders[NAME_ERROR.to_s]
    DidYouMean.finders[NAME_ERROR.to_s] = TestFinder

    @error = assert_raises(NAME_ERROR){ doesnt_exist }
  end

  def teardown
    DidYouMean.finders[NAME_ERROR.to_s] = @org
  end

  def test_message
    assert_match "Y U SO SLOW?", @error.to_s
    assert_match "Y U SO SLOW?", @error.message
  end
end

class IgnoreCallersTest < Minitest::Test
  class Boomer
    def initialize(*)
      raise Exception, "finder was created when it shouldn't!"
    end
  end

  def setup
    @org = DidYouMean.finders[NAME_ERROR.to_s]
    DidYouMean.finders[NAME_ERROR.to_s] = Boomer

    @error = assert_raises(NAME_ERROR){ doesnt_exist }
  end

  def teardown
    DidYouMean.finders[NAME_ERROR.to_s] = @org
  end

  def test_ignore_missing_name
    assert_nothing_raised { missing_name }
  end

  def test_ignore_safe_constantize
    assert_nothing_raised { safe_constantize }
  end

  private

  def safe_constantize; @error.message end
  def missing_name;     @error.message end

  def assert_nothing_raised
    yield
  end
end

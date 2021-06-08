require_relative './helper'

class VerboseFormatterTest < Test::Unit::TestCase
  def setup
    require_relative File.join(DidYouMean::TestHelper.root, 'verbose')

    DidYouMean.formatter = DidYouMean::VerboseFormatter.new
  end

  def teardown
    DidYouMean.formatter = DidYouMean::PlainFormatter.new
  end

  def test_message
    @error = assert_raise(NoMethodError){ 1.zeor? }

    expected = /
      undefined\smethod\s`zeor\?'\sfor\s1:Integer\n
      \n
      (?:\s\s\s\s@error\s=\sassert_raise\(NoMethodError\)\{\s1\.zeor\?\s\}\n
      \s{43}\^\^\^\^\^\^\n
      \n)?
      \s\s\s\sDid\ you\ mean\?\ zero\?
    /x
    assert_match expected, @error.message
  end
end

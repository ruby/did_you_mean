require_relative 'test_helper'

require 'better_errors'
require 'did_you_mean/better_errors'

class BetterErrorsIntegrationTest < Minitest::Test
  def setup
    exception   = assert_raises(NameError){ Objcet }
    @error_page = ::BetterErrors::ErrorPage.new exception, { "PATH_INFO" => "/some/path" }
  end

  def test_do_variables_outputs_suggestions
    html = @error_page.do_variables("index" => 0)[:html]

    assert_includes html, "Did you mean?"
    assert_includes html, "Object"
  end
end

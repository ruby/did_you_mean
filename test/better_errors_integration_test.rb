require 'test_helper'

class BetterErrorsIntegrationTest < Minitest::Test
  def setup
    exception   = assert_raises(NameError){ Objcet }
    @error_page = ::BetterErrors::ErrorPage.new exception, { "PATH_INFO" => "/some/path" }
  end

  def test_render_doesnt_output_suggestions
    html = @error_page.render

    refute_includes html, "Did you mean?"
  end

  def test_do_variables_outputs_suggestions
    html = @error_page.do_variables("index" => 0)[:html]

    assert_includes html, "Did you mean?"
    assert_includes html, "Object"
  end
end if defined?(::BetterErrors)

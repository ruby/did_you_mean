require_relative '../helper'

class ExperimentalMethodNameCorrectionTest < Test::Unit::TestCase
  include DidYouMean::TestHelper

  require_relative "#{DidYouMean::TestHelper.root}/experimental/ivar_name_correction"
  DidYouMean::Experimental::IvarNameChecker::TRACE.disable
  DidYouMean::SPELL_CHECKERS['NoMethodError'] = DidYouMean::MethodNameChecker

  def setup
    DidYouMean::SPELL_CHECKERS['NoMethodError'] = DidYouMean::Experimental::IvarNameChecker
  end

  def teardown
    DidYouMean::SPELL_CHECKERS['NoMethodError'] = DidYouMean::MethodNameChecker
  end

  def test_corrects_incorrect_ivar_name
    @number = 1
    @nubmer = nil

    DidYouMean::Experimental::IvarNameChecker::TRACE.enable do
      error = assert_raise(NoMethodError) { @nubmer.zero? }
      remove_instance_variable :@nubmer

      assert_correction :@number, error.corrections
      assert_match "Did you mean?  @number", error.to_s
    end
  end
end

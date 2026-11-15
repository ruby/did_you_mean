require_relative '../helper'

class NameErrorExtensionTest < Test::Unit::TestCase
  include DidYouMean::TestHelper

  SPELL_CHECKERS = DidYouMean.spell_checkers

  class TestSpellChecker
    def initialize(*); end
    def corrections; ["does_exist"]; end
  end

  def setup
    @original_spell_checker = DidYouMean.spell_checkers['NameError']
    DidYouMean.correct_error(NameError, TestSpellChecker)

    @error = assert_raise(NameError){ doesnt_exist }
  end

  def teardown
    DidYouMean.correct_error(NameError, @original_spell_checker)
  end

  def test_message
    if Exception.method_defined?(:detailed_message)
      assert_match(/Did you mean\?  does_exist/, @error.detailed_message)
    else
      assert_match(/Did you mean\?  does_exist/, @error.to_s)
      assert_match(/Did you mean\?  does_exist/, @error.message)
    end
  end

  def test_to_s_does_not_make_disruptive_changes_to_error_message
    error = assert_raise(NameError) do
      raise NameError, "uninitialized constant Object"
    end

    get_message(error)
    assert_equal 1, get_message(error).scan("Did you mean?").count
  end

  def test_correctable_error_objects_are_dumpable
    error =
      begin
        Dir.chdir(__dir__) { File.open('test_name_error_extension.rb') { |f| f.sizee } }
      rescue NoMethodError => e
        e
      end

    get_message(error)

    assert_match(/^undefined method [`']sizee' for /,
                 Marshal.load(Marshal.dump(error)).original_message)
  end
end

class NameErrorMessageEvaluationTest < Test::Unit::TestCase
  def test_to_s_inspects_receiver_at_most_once
    count    = 0
    receiver = Object.new
    receiver.define_singleton_method(:inspect) { count += 1; "receiver" }

    error = assert_raise(NameError) { receiver.instance_eval { doesnt_exist } }
    error.to_s

    assert_operator count, :<=, 1
    assert_not_include error.instance_variables, :@original_message
  end

  class RecursiveInspect
    def bar
      zoo_1
    rescue => e
      raise e.class, e.message
    end

    def zoo
      true
    end

    def inspect
      bar
    end
  end

  def test_message_with_inspect_that_raises_name_error
    omit "JRuby 9.4 raises StackOverflowError" if RUBY_ENGINE == "jruby" && !Exception.method_defined?(:detailed_message)

    error = assert_raise(NameError) { RecursiveInspect.new.bar }

    assert_match(/undefined local variable or method [`']zoo_1'/, error.message)
    assert_include error.message, "Did you mean?  zoo" unless error.respond_to?(:detailed_message)
  end

  def test_to_s_with_correctable_prepended_twice
    error_class = Class.new(NameError)
    error_class.prepend(DidYouMean::Correctable)

    assert_equal "message", error_class.new("message").to_s
  end

  def test_to_s_with_exception_method_overridden
    error_class = Class.new(NameError) do
      def exception(*args)
        args.empty? ? self : RuntimeError.new("other")
      end
    end

    assert_equal "message", error_class.new("message").to_s
  end
end

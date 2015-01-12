require_relative 'test_helper'

class SimilarClassMethodFinderTest < Minitest::Test

  class User
    class << self
      def last_name; end
    end

    class << self
      def pass; end
    end
  end

  module Users
    class << self
      def last_names; end
    end
  end

  def setup
    @error_from_similar_class_method  = assert_raises(NoMethodError){ Users.last_name }
    @error_from_similar_module_method  = assert_raises(NoMethodError){ Users.pass }
  end

  def test_similar_words
    assert_suggestions @error_from_similar_class_method.suggestions,  %w{last_names SimilarClassMethodFinderTest::User.last_name}
    assert_suggestions @error_from_similar_module_method.suggestions, %w{hash class SimilarClassMethodFinderTest::User.pass SimilarClassMethodFinderTest::User.hash SimilarClassMethodFinderTest::User.class}
  end

  def test_did_you_mean?
    assert_match "Did you mean? .last_names\n                  SimilarClassMethodFinderTest::User.last_name",  @error_from_similar_class_method.did_you_mean?
    assert_match ["Did you mean? .hash",
                  ".class",
                  "SimilarClassMethodFinderTest::User.pass",
                  "SimilarClassMethodFinderTest::User.hash",
                  "SimilarClassMethodFinderTest::User.class"
                 ].join("\n                  "), @error_from_similar_module_method.did_you_mean?
  end

end
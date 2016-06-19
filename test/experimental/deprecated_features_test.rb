require 'test_helper'

class DeprecatedExtraFeaturesTest < Minitest::Test
  def test_message
    message = "The file 'did_you_mean/extra_features.rb' has been moved to " \
              "'did_you_mean/experimental.rb'. Please `require 'did_you_mean/experimental'` " \
              "instead.\n"

    assert_output nil, message do
      require 'did_you_mean/extra_features'
    end
  end
end

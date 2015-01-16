require_relative 'null_finder_test'
require_relative 'word_collection_test'
require_relative 'name_error_extension_test'
require_relative 'similar_name_finder_test'
require_relative 'similar_method_finder_test'
require_relative 'similar_class_method_finder_test'
require_relative 'no_method_error_extension_test'

if defined?(ActiveRecord)
  require_relative 'similar_attribute_finder_test'
end

if defined?(::BetterErrors)
  require_relative 'better_errors_integration_test'
end

require_relative 'similar_class_finder_test'
require_relative 'pry_formatter_test'

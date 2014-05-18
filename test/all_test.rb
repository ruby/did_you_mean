require_relative 'similar_name_finder_test'
require_relative 'similar_method_finder_test'

if defined?(ActiveRecord)
  require_relative 'similar_attribute_finder_test'
end

require_relative 'similar_class_finder_test'

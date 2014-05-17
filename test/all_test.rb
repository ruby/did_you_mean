require_relative 'similar_name_finder_test'
require_relative 'similar_method_finder_test'

if defined?(ActiveRecord)
  require_relative 'similar_attribute_finder_test'
end

begin
  RaiseNameError
rescue NameError => e
  if e.name
    require_relative 'similar_class_finder_test'
  else
    require_relative 'similar_class_finder_test_without_name'
  end
end

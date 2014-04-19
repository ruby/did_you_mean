class NoMethodError
  def receiver
    if self.is_a?(ActiveRecord::UnknownAttributeError)
      frame_binding.eval("self.class")
    else
      args.first
    end
  end

  def did_you_mean?
    if self.is_a?(ActiveRecord::UnknownAttributeError)
      return if similar_columns.empty?
    else
      return if similar_methods.empty?
    end

    output = "\n\n"

    if self.is_a?(ActiveRecord::UnknownAttributeError)
      output << "    Did you mean? #{similar_columns.first}\n"
      output << similar_columns[1..-1].map{|word| "#{' ' * 18}#{word}\n" }.join
    else
      output << "   Did you mean? #{separator}#{similar_methods.first}\n"
      output << similar_methods[1..-1].map{|word| "#{' ' * 17}#{separator}#{word}\n" }.join
    end
  end

  def similar_methods
    @similar_methods ||= DidYouMean::MethodFinder.new(receiver.methods + receiver.singleton_methods, name).similar_methods
  end

  def receiver_name
    class_method? ? receiver.name : receiver.class.name
  end

  def separator
    class_method? ? "." : "#"
  end

  def class_method?
    receiver.is_a? Class
  end

  # for ActiveRecord::UnknownAttributeError
  def similar_columns
    @similar_columns ||= DidYouMean::MethodFinder.new(column_names, unknown_attribute_name).similar_methods
  end

  def column_names
    @column_names ||= frame_binding.eval("self.class").column_names
  end

  def unknown_attribute_name
    @unknown_attribute_name ||= original_message.gsub("unknown attribute: ", "")
  end
end

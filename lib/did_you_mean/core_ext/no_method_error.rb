class NoMethodError
  def receiver
    args.first
  end

  def did_you_mean?
    return if similar_methods.empty?

    output = "\n\n"
    output << "   Did you mean? #{separator}#{similar_methods.first}\n"
    output << similar_methods[1..-1].map{|word| "#{' ' * 17}#{separator}#{word}\n" }.join
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
end

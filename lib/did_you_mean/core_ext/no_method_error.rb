class NoMethodError
  def receiver
    args.first
  end

  def did_you_mean?
    return if similar_methods.empty?

    output << "Did you mean?" << "\n"
    output << similar_methods.map{|word| "\t#{receiver_name}#{separator}#{word}" }.join("\n") << "\n"
    output << "\n"
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

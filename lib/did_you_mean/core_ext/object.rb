class Object
  def method_missing(method_name, *args, &block)
    super
  rescue NoMethodError => error
    error.instance_variable_set(:@receiver, self)
    raise error
  end
end

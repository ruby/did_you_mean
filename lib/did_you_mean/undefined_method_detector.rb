class UndefinedMethodDetector
  def initialize(dir)
    @dir = dir
  end

  def undefined_methods
    called_methods = {}

    methods_defined_in(@dir).each do |method|
      ops = RubyVM::InstructionSequence.of(method).to_a[13]
      next unless ops

      called_method_detector = CalledMethodDetector.new
      called_method_detector.detect_called_methods(ops)
      called_method_detector.called_methods.each do |called_method_name|
        called_methods[called_method_name] ||= []
        called_methods[called_method_name] << method
      end
    end

    called_methods
      .select {|called_method_name, _| !all_defined_method_names.include?(called_method_name) }
      .map {|name, methods_calling_undefined_method| UndefinedMethod.new(name, methods_calling_undefined_method) }
  end

  private

  def methods_defined_in(dir)
    all_defined_methods.select do |method|
      method.source_location && (method.source_location[0].start_with?(dir) || !method.source_location[0].start_with?('/'))
    end
  end

  def all_defined_method_names
    @all_defined_method_names ||= all_defined_methods.map(&:name)
  end

  METHOD_METHOD = Object.instance_method(:method)

  def all_defined_methods
    @all_defined_methods ||= ObjectSpace.each_object.flat_map do |obj|
      methods = []

      if Module === obj
        methods.concat obj.instance_methods(false).map {|msym| obj.instance_method(msym) }
        methods.concat obj.private_instance_methods(false).map {|msym| obj.instance_method(msym) }
      end
      unless Integer === obj || Float === obj || Symbol === obj || String === obj
        methods.concat obj.singleton_methods(false).map {|msym| METHOD_METHOD.bind(obj).call(msym) }
        methods.concat obj.singleton_class.private_instance_methods(false).map {|msym| METHOD_METHOD.bind(obj).call(msym) }
      end

      methods
    end
  end

  class CalledMethodDetector
    def initialize
      @called_methods = []
    end

    def detect_called_methods(operands)
      if operands.is_a?(Array) && (operands[0] == :opt_send_simple || operands[0] == :opt_send_without_block)
        @called_methods << operands
      else
        operands.each {|op| detect_called_methods(op) } if operands.is_a?(Array)
      end
    end

    def called_methods
      @called_methods.map {|op| op[1][:mid] }
    end
  end

  class UndefinedMethod
    attr_reader :name, :called_by

    def initialize(name, called_by)
      @name, @called_by = name, called_by
    end
  end

  private_constant :CalledMethodDetector, :UndefinedMethod
end


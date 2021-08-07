require_relative "../spell_checker"

module DidYouMean
  class MethodNameChecker
    attr_reader :method_name, :receiver

    NIL_METHODS = nil.methods
    private_constant :NIL_METHODS
    Ractor.make_shareable(NIL_METHODS) if defined?(Ractor)

    def self.create_initial_names_to_exclude_map
      initial_map = { NilClass => NIL_METHODS }
      initial_map.default = []
      initial_map
    end

    private_class_method :create_initial_names_to_exclude_map

    if defined?(Ractor)
      def self.names_to_exclude_map
        Ractor.current[:__DidYouMean_MethodNameChecker_Names_To_Exclude__] ||= create_initial_names_to_exclude_map
      end
    else
      def self.names_to_exclude_map
        NAMES_TO_EXCLUDE
      end
    end

    NAMES_TO_EXCLUDE = create_initial_names_to_exclude_map

    # +MethodNameChecker::RB_RESERVED_WORDS+ is the list of reserved words in
    # Ruby that take an argument. Unlike
    # +VariableNameChecker::RB_RESERVED_WORDS+, these reserved words require
    # an argument, and a +NoMethodError+ is raised due to the presence of the
    # argument.
    #
    # The +MethodNameChecker+ will use this list to suggest a reversed word if
    # a +NoMethodError+ is raised and found closest matches.
    #
    # Also see +VariableNameChecker::RB_RESERVED_WORDS+.
    RB_RESERVED_WORDS = %i(
      alias
      case
      def
      defined?
      elsif
      end
      ensure
      for
      rescue
      super
      undef
      unless
      until
      when
      while
      yield
    )
    Ractor.make_shareable(RB_RESERVED_WORDS) if defined?(Ractor)

    def initialize(exception)
      @method_name  = exception.name
      @receiver     = exception.receiver
      @private_call = exception.respond_to?(:private_call?) ? exception.private_call? : false
    end

    def corrections
      @corrections ||= begin
                         dictionary = method_names
                         dictionary = RB_RESERVED_WORDS + dictionary if @private_call

                         SpellChecker.new(dictionary: dictionary).correct(method_name) - names_to_exclude
                       end
    end

    def method_names
      if Object === receiver
        method_names = receiver.methods + receiver.singleton_methods
        method_names += receiver.private_methods if @private_call
        method_names.uniq!
        method_names
      else
        []
      end
    end

    def names_to_exclude
      Object === receiver ? MethodNameChecker.names_to_exclude_map[receiver.class] : []
    end
  end
end

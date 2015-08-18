require 'delegate'

module DidYouMean
  class ClassNameChecker
    include SpellCheckable
    attr_reader :class_name, :original_message

    def initialize(exception)
      @class_name, @original_message = exception.name, exception.original_message
    end

    def candidates
      {name_from_message => class_names}
    end

    def class_names
      scopes.flat_map do |scope|
        scope.constants.map do |c|
          ClassName.new(c, scope == Object ? EMPTY : "#{scope}::")
        end
      end
    end

    def name_from_message
      class_name || /([A-Z]\w*$)/.match(original_message)[0]
    end

    def corrections
      super.map(&:full_name)
    end

    def scopes
      @scopes ||= scope_base.inject([Object]) do |_scopes, scope|
        _scopes << _scopes.last.const_get(scope)
      end
    end

    private

    def scope_base
      @scope_base ||= (/(([A-Z]\w*::)*)([A-Z]\w*)$/ =~ original_message ? $1 : "").split("::")
    end

    class ClassName < SimpleDelegator
      attr :namespace

      def initialize(name, namespace = '')
        super(name)
        @namespace = namespace
      end

      def full_name
        self.class.new("#{namespace}#{__getobj__}")
      end
    end

    private_constant :ClassName
  end
end

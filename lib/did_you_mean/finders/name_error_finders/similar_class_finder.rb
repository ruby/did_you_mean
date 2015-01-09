module DidYouMean
  class SimilarClassFinder
    include BaseFinder
    attr_reader :class_name, :original_message

    def initialize(exception)
      @class_name, @original_message = exception.name, exception.original_message
      autoload_class_name_inflector
    end

    def words
      scopes.flat_map do |scope|
        scope.constants.map do |c|
          StringDelegator.new(c.to_s, :constant, prefix: (scope == Object ? EMPTY : "#{scope}::"))
        end
      end
    end

    def name_from_message
      class_name || /([A-Z]\w*$)/.match(original_message)[0]
    end
    alias target_word name_from_message

    def suggestions
      super.map(&:with_prefix)
    end

    def scopes
      @scopes ||= scope_base.inject([Object]) do |_scopes, scope|
        _scopes << _scopes.last.const_get(scope)
      end
    end

    private

    def autoload_class_name_inflector
      return unless defined?(Rails)
      name_is_singular = name_from_message.to_s.pluralize.singularize == name_from_message.to_s
      class_name_inflector = name_is_singular ? name_from_message.to_s.pluralize : name_from_message.to_s.singularize
      class_name_inflector.safe_constantize
    end

    def scope_base
      @scope_base ||= (/(([A-Z]\w*::)*)([A-Z]\w*)$/ =~ original_message ? $1 : "").split("::")
    end
  end
end

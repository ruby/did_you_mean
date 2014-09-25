module DidYouMean
  class SimilarClassFinder < BaseFinder
    attr_reader :class_name, :original_message

    def initialize(exception)
      @class_name, @original_message = exception.name, exception.original_message
    end

    def similar_classes
      @similar_classes ||= scopes.map do |scope|
        WordCollection.new(scope.constants).similar_to(name_from_message).map do |constant_name|
          if scope === Object
            constant_name.to_s
          else
            "#{scope}::#{constant_name}"
          end
        end
      end.flatten
    end
    alias similar_words similar_classes

    private

    def name_from_message
      class_name || /([A-Z]\w*$)/.match(original_message)[0]
    end

    def scope_base
      @scope_base ||= (/(([A-Z]\w*::)*)([A-Z]\w*)$/ =~ original_message ? $1 : "").split("::")
    end

    def scopes
      @scopes ||= scope_base.size.times.map do |count|
        eval(scope_base[0..(- count)].join("::"))
      end.reverse << Object
    end
  end
end

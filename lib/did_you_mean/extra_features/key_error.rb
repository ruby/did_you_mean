module DidYouMean
  module ExtraFeatures
    module KeyErrorWithNameAndKeys
      FILE_REGEXP = %r"#{Regexp.quote(__FILE__)}"

      def fetch(name, *)
        super
      rescue KeyError => e
        e.instance_variable_set(:@name, name)
        e.instance_variable_set(:@keys, keys)
        $@.delete_if { |s| FILE_REGEXP =~ s } if $@
        raise e
      end
    end
    Hash.prepend KeyErrorWithNameAndKeys
    KeyError.send(:attr, :name, :keys)

    class KeyNameChecker
      include SpellCheckable
      def initialize(key_error)
        @name = key_error.name
        @keys = key_error.keys
      end

      def candidates
        { @name => @keys }
      end

      def corrections
        super.map(&:inspect)
      end
    end
    SPELL_CHECKERS["KeyError"] = KeyNameChecker
    KeyError.prepend DidYouMean::Correctable
  end
end

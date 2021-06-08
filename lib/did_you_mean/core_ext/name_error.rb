module DidYouMean
  module Correctable
    def original_message
      method(:to_s).super_method.call
    end

    def to_s
      msg = super.dup
      suggestion = DidYouMean.formatter.message_for(corrections)

      msg << suggestion if !msg.include?(suggestion)
      msg
    rescue
      super
    end

    def corrections
      @corrections ||= spell_checker.corrections
    end

    def spell_checker
      SPELL_CHECKERS[self.class.to_s].new(self)
    end
  end

  module Pointable
    def to_s
      msg = super.dup

      locs = backtrace_locations
      return msg unless locs

      loc = locs.first
      path = loc.absolute_path
      nd_call = RubyVM::AbstractSyntaxTree.of(loc)
      if path && nd_call
        case nd_call.type
        when :OP_ASGN1, :OP_ASGN2, :OP_ASGN_AND, :OP_ASGN_OR, :OP_CDECL, :CALL, :OPCALL, :FCALL, :VCALL, :QCALL
          nd_recv = nd_call.children[0]
          if nd_recv.is_a?(RubyVM::AbstractSyntaxTree::Node) && nd_call.last_lineno == nd_recv.last_lineno
            beg_column = nd_recv.last_column
            end_column = nd_call.last_column
            marker = " " * beg_column + "^" * (end_column - beg_column)
            line = File.foreach(path).drop(nd_call.last_lineno - 1).first
            points = "\n\n#{line}#{marker}"
            msg << points if line && !msg.include?(points)
          end
        end
      end

      msg

    rescue Exception

      msg
    end
  end
end

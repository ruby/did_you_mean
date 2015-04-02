class NameError
  attr_reader :frame_binding

  IGNORED_CALLERS = [
    /( |`)missing_name'/,
    /( |`)safe_constantize'/
  ].freeze
  private_constant :IGNORED_CALLERS

  __to_s__ = instance_method(:to_s)
  define_method(:original_message){ __to_s__.bind(self).call }

  def to_s
    msg = original_message
    msg << did_you_mean?.to_s if IGNORED_CALLERS.all? {|ignored| caller.first(8).grep(ignored).empty? }
    msg
  rescue
    original_message
  end

  def did_you_mean?
    DidYouMean.formatter.new(suggestions).to_s if DidYouMean.enabled? && !suggestions.empty?
  end

  def suggestions
    finder.suggestions
  end

  def finder
    @finder ||= DidYouMean.finders[self.class.to_s].new(self)
  end
end

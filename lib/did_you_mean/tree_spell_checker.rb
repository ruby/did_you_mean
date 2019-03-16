# spell checker for a dictionary that has a tree structure
class TreeSpellCheckerTest
  def structured(dictionary)
    states = plausible_states dictionary
    nodes = states[0].product(*states[1..-1])
    paths = possible_paths nodes
    suffix = relative_file_name.split('/').last
    paths.map do |path|
      names = base_names(path, dictionary)
      checker = ::DidYouMean::SpellChecker.new(:dictionary => names)
      ideas = checker.correct(suffix)
      if ideas.empty?
        nil
      else
        ideas.map { |str| path + '/' + str }
      end
    end.compact.flatten
  end

  private

  def base_names(node, dictionary)
    dictionary.map do |str|
      str.gsub("#{node}/", '') if str.include? "#{node}/"
    end.compact
  end
end
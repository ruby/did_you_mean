# spell checker for a dictionary that has a tree structure
class TreeSpellChecker
  attr_reader :dictionary, :all_states

  def initialize(dictionary:)
    @dictionary = dictionary
    @all_states = parse
  end

  def correct(input)
    states = plausible_states input
    nodes = states[0].product(*states[1..-1])
    paths = possible_paths nodes
    suffix = input.split('/').last
    paths.map do |path|
      names = base_names(path)
      checker = ::DidYouMean::SpellChecker.new(dictionary: names)
      ideas = checker.correct(suffix)
      if ideas.empty?
        nil
      else
        ideas.map { |str| path + '/' + str }
      end
    end.compact.flatten
  end

  private

  def base_names(node)
    dictionary.map do |str|
      str.gsub("#{node}/", '') if str.include? "#{node}/"
    end.compact
  end

  def possible_paths(nodes)
    nodes.map do |node|
      node.join '/'
    end
  end

  def plausible_states(input)
    elements = input.split('/')
    elements.each_with_index.map do |str, i|
      next if all_states[i].nil?
      if all_states[i].include? str
        [str]
      else
        checker = ::DidYouMean::SpellChecker.new(dictionary: all_states[i])
        checker.correct(str)
      end
    end.compact
  end

  def parse
    parts_a = dictionary.map do |a|
      parts = a.split('/')
      parts[0..-2]
    end.to_set.to_a
    max_parts = parts_a.map { |parts| parts.size }.max
    nodes =Array.new(max_parts){[]}
    (0...max_parts).each do |i|
      parts_a.each do |parts|
        nodes[i] << parts[i] unless parts[i].nil?
      end
    end
    nodes.map do |node|
      node.to_set.to_a
    end
  end
end
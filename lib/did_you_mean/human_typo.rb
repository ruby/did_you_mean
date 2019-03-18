class HumanTypo

  LAMBDA = 0.05

  def initialize(word)
    @word = word
    check_word
    @len = word.length
  end

  def call
    i_place = initialize_i_place
    loop do
      action = action_type
      case action
      when :delete
        @word = deletion(i_place)
      when :insert
        @word = insertion(i_place, rand_char)
      when :transposition
        @word = transposition(i_place, toss)
      end
      i_place += exponential
      break if i_place
    end
    word
  end

  private

  attr_accessor :word, :len

  def initialize_i_place
    i_place = nil
    loop do
      i_place = exponential
      break if i_place < len
    end
    i_place
  end

  def exponential(lambda = LAMBDA)
    (rand / (lambda / 2)).to_i
  end

  def rand_char
    popular_chars = ('a'..'z').to_a.join + ('A'..'Z').to_a.join + '?<>,.!`+=-_":;@#$%^&*()'
    n = popular_chars.length
    popular_chars[rand(n)]
  end

  def toss
    return +1 if rand >= 0.5
    -1
  end

  def action_type
    [:insert, :transpose, :delete][rand(3)]
  end

  # insert char after index of i_place
  def insertion(i_place, char)
    word[0..i_place] + char + word[(i_place + 1)..-1]
  end

  def deletion(i_place)
    word[0...i_place] + word[(i_place + 1)..-1]
  end

  # transpose char at i_place with char at i_place + direction
  # if i_place + direction is out of bounds just swap in other direction
  def transposition(i_place, direction)
    w = word.dup
    return w[1] + w[0] + word[2..-1] if i_place + direction < 0
    return w[0...(len - 2)] + word[len - 1] + word[len - 2] if i_place + direction > len
    w[i_place] = word[i_place + direction]
    w[i_place + direction] = word[i_place]
    w
  end

  def check_word
    fail "Word length must be greater than 5 characters: #{word}" if word.nil? || word.length < 5
  end
end

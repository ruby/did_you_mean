# Simulate a error prone human typist
# Assumes typographical errors are Poisson distributed and
# each error is either a deletion, insertion, or transposition
class TreeSpellHumanTypo
  LAMBDA = 0.05 # The typographical error rate of the Poisson distribution

  def initialize(input)
    @input = input
    check_input
    @len = input.length
  end

  def call
    @word = input.dup
    i_place = initialize_i_place
    loop do
      action = action_type
      @word = make_change action, i_place
      @len = word.length
      i_place += exponential
      break if i_place >= len
    end
    word
  end

  def insertion_test(i_place, char)
    @word = input.dup
    insertion(i_place, char)
  end

  def deletion_test(i_place)
    @word = input.dup
    deletion(i_place)
  end

  def transposition_test(i_place, direction)
    @word = input.dup
    transposition(i_place, direction)
  end

  private

  attr_accessor :input, :word, :len

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
    popular_chars =  alphabetic_characters + special_characters
    n = popular_chars.length
    popular_chars[rand(n)]
  end

  def alphabetic_characters
    ('a'..'z').to_a.join + ('A'..'Z').to_a.join
  end

  def special_characters
    '?<>,.!`+=-_":;@#$%^&*()'
  end

  def toss
    return +1 if rand >= 0.5
    -1
  end

  def action_type
    [:insert, :transpose, :delete][rand(3)]
  end

  def make_change(action, i_place)
    case action
    when :delete
      deletion(i_place)
    when :insert
      insertion(i_place, rand_char)
    when :transpose
      transposition(i_place, toss)
    end
  end

  # insert char after index of i_place
  def insertion(i_place, char)
    return char + word if i_place == 0
    return word + char if i_place == len - 1
    word.insert(i_place + 1, char)
  end

  def deletion(i_place)
    word.slice!(i_place)
    word
  end

  # transpose char at i_place with char at i_place + direction
  # if i_place + direction is out of bounds just swap in other direction
  def transposition(i_place, direction)
    w = word.dup
    return  swap_first_two(w) if i_place + direction < 0
    return  swap_last_two(w) if i_place + direction >= len
    swap_two(w, i_place, direction)
    w
  end

  def swap_first_two(w)
    w[1] + w[0] + word[2..-1]
  end

  def swap_last_two(w)
    w[0...(len - 2)] + word[len - 1] + word[len - 2]
  end

  def swap_two(w, i_place, direction)
    w[i_place] = word[i_place + direction]
    w[i_place + direction] = word[i_place]
  end

  def check_input
    fail check_input_message if input.nil? || input.length < 5
  end

  def check_input_message
    "input length must be greater than 5 characters: #{input}"
  end
end

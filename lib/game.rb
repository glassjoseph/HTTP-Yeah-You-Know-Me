class Game
  attr_reader :answer
  attr_accessor :guesses, :last_guess

  def initialize
    @answer = (rand(100)+1)
    @guesses = 0
    @last_guess = "No guess made"
  end

  def guess(guessed_number)
    @guesses += 1 
    @last_guess = guessed_number
    return nil
  end

  def info
    "Guesses: #{guesses}\n<br>Last guess: #{last_guess}\n<br>Answer is #{compare_guess} your guess."
  end

  def compare_guess
      if last_guess.is_a?(String)
        "not compared to"
      elsif last_guess == answer
        "exactly equal to"
      elsif last_guess > answer
        "lower than"
      elsif last_guess < answer
        "higher than"
      end
  end
  
  # binding.pry
  ""
end
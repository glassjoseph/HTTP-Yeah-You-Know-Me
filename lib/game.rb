# When a player starts a new game, the server picks a random number between 0 and 100.
# The player can make a new guess by sending a POST request containing the number they want to guess.
# When the player requests the game path, the server should show some information about the game including how many guesses have been made, what the most recent guess was, and whether it was too high, too low, or correct.


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
require "minitest/autorun"
require "minitest/pride"
require "./lib/server.rb"



class GameTest < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_game_initialized
    new_game = Game.new
    # binding.pry
    answer = new_game.answer
    guesses = new_game.guesses
    last_guess = new_game.last_guess

    assert answer.is_a?(Integer)
    assert_equal 0, guesses
    assert_equal "", last_guess
  end
  
  def test_guess_increments_guesses
     new_game = Game.new
     guesses = new_game.guess
     assert_equal 1, guesses
  end

    def test_guess_logs_last_guess
    skip
     new_game = Game.new
     new_game.guess
     assert_equal 0, new_game.last_guess
    end

end
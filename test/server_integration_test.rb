require "minitest/autorun"
require "minitest/pride"
# require "./lib/server"
require "faraday"
require 'pry'

class ServerTest < Minitest::Test
i_suck_and_my_tests_are_order_dependent!

  def setup  
    @conn = Faraday.new 'http://127.0.0.1:9292'

  end
  
  def get_body(request)
    request.body.split("<body>")[1].split("<pre>")[0]
  end


  def test_server_receives_lines
 
    request = @conn.get 
    refute request.body.nil?
  end


  # def test_all_server_variables_initialze_at_zero
 
  #    requests = server.requests
  #    assert_equal 0, requests
  # end

  def test_say_hello_says_hello
    request =  @conn.get "/hello"
    hello = get_body(request)
    assert_equal "Hello World" , hello[0..10]

  end

  def test_datetime_outputs_time
    request =  @conn.get "/datetime"
    time = get_body(request)
    assert_equal DateTime.now.strftime('%l:%M%p on %A, %b %e, %Y') , time
  end

  def test_z_shutdown_shuts_down
    skip
    request =  @conn.get "/shutdown"
    shutdown = get_body(request)
    assert_equal "Total Requests" , shutdown[0..13]

  end

  def test_word_check
    request =  @conn.get "/word_search?word=hydrencephalocele"
    a_word = get_body(request)
    request =  @conn.get "/word_search?word=freedo"
    not_a_word = get_body(request)
    assert_equal "hydrencephalocele is a known word" , a_word
    assert_equal "freedo is not a known word", not_a_word
  end

  def test_a_start_game
    request =  @conn.post "/start_game"
    start = get_body(request)
    assert_equal "Good Luck!" , start
  end

  def test_can_get_info
    request =  @conn.get "/game"
    info = get_body(request)
    assert_equal "Guesses: 0\n<br>Last guess: No guess made\n<br>Answer is not compared to your guess." , info
  end

  def test_you_can_post_a_guess
    # binding.pry
    request =  @conn.post "/start_game"
    request =  @conn.post "/game" do |guess|
      guess.body = "guess=54"
      end
    guess = get_body(request)
    assert_equal "Guesses: \n<br>Last guess: No guess made\n<br>Answer is not compared to your guess." , guess
  end

end
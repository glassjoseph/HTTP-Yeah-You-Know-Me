require "minitest/autorun"
require "minitest/pride"
require "./lib/server"
# require "faraday"


class ServerTest < Minitest::Test
  def setup
    @server = Server.new
    # @server.start
    @request_lines = 	["GET /word_search?word=zebra HTTP/1.1",
	 "Host: 127.0.0.1:9292",
	 "Connection: keep-alive",
	 "Cache-Control: no-cache",
	 "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
	 "Postman-Token: 2fa75e50-0280-3605-1ed9-49e9790972f9",
	 "Accept: */*",
	 "Accept-Encoding: gzip, deflate, sdch, br",
   "Accept-Language: en-US,en;q=0.8"]
  #  
  # @ip = Faraday.new 'http://127.0.0.1:9292/'

  end
  
  # binding.pry
  
  def test_server_exists
    assert_instance_of Server, @server
  end

  # def test_server_receives_lines
  #   # @server.start
  #   @ip.get 
  #   binding.pry

  #     assert "server", @server
  # end


  def test_say_hello_says_hello
    # request = @ip.get "/hello"
    hello =  @server.say_hello
    assert_equal "Hello World (1)", hello

  end

  def test_say_hello_increments
    hello = 4.times {@server.say_hello}
    assert_equal 4, hello
  end

  def test_server_requests_initialze_at_zero
     server = Server.new
     requests = server.requests
     assert_equal 0, requests
  end

  def test_server_increments_requests
     @server.respond
     @server.respond
     @server.respond          
     requests = @server.requests
     assert_equal 3, requests
  end

  def test_extract_requests
    extracted = @server.extract_request(@request_lines)
    assert_equal "Verb: GET\nPath: /word_search\nProtocol: HTTP/1.1\nHost:  127.0.0.1\nPort: 9292\nOrigin:  127.0.0.1\nAccept: */*", extracted
  end

  def test_check_word
    @server.path = "/word_search"
    @server.word = "hydrencephalocele"
    a_word = @server.check_word

    @server.path = "/word_search"
    @server.word = "freedo"
    not_a_word = @server.check_word

    assert_equal "hydrencephalocele is a known word", a_word
    assert_equal "freedo is not a known word", not_a_word
  end

  def test_initializes_game
    @server.path = "/start_game"
    @server.verb = "POST"

    @server.respond
    game = @server.game
    assert_instance_of Game, game
  end

  def test_gives_game_info
    @server.path = "/start_game"
    @server.verb = "POST"
    @server.respond
    
    @server.path = "/game"
    @server.verb = "GET"
    info = @server.respond

    assert_equal "Guesses: 0\n<br>Last guess: No guess made\n<br>Answer is not compared to your guess.", info
  end

  #  def test_game_info_increments
  #   @server.path = "/start_game"
  #   @server.verb = "POST"
  #   @server.respond
    

  #   @server.
  #   @server.path = "/game"
  #   @server.verb = "GET"
  #   info = @server.respond

  #   assert_equal "Guesses: 1\n<br>Last guess: No guess made\n<br>Answer is not compared to your guess.", info
  # end


end
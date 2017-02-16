require "minitest/autorun"
require "minitest/pride"
require "./lib/server"
require "faraday"
# require "./lib/game"


class ServerTest < Minitest::Test
  def setup
    @server = Server.new
  end
  def test_server_exists
    assert_instance_of Server, @server
  end

  def test_server_receives_lines
    # @server.start
    #  assert "server", @server
  end

  def test_server_increments_requests
     @server.respond
     requests = @server.requests
     refute_equal "0", requests
  end

  def test_extract_requests
    request_lines = 	["GET / HTTP/1.1",
	 "Host: 127.0.0.1:9292",
	 "Connection: keep-alive",
	 "Cache-Control: no-cache",
	 "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
	 "Postman-Token: 2fa75e50-0280-3605-1ed9-49e9790972f9",
	 "Accept: */*",
	 "Accept-Encoding: gzip, deflate, sdch, br",
   "Accept-Language: en-US,en;q=0.8"]
    extracted = @server.extract_request(request_lines)
    assert_equal "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost:  127.0.0.1\nPort: 9292\nOrigin:  127.0.0.1\nAccept: */*", extracted
  end

  def test_check_word
    @server.path = "/word_search?word=hydrencephalocele"
    a_word = @server.check_word
    @server.path = "/word_search?word=freedo"
    not_a_word = @server.check_word

    assert_equal "hydrencephalocele is a known word", a_word
    assert_equal "freedo is not a known word", not_a_word
  end

  def test_initializes_game
    game = @server.new_game
    assert_instance_of Game, game
  end

end
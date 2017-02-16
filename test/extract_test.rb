require "minitest/autorun"
require "minitest/pride"
require "./lib/server"
# require "faraday"
# require "./lib/game"


class ExtractTest < Minitest::Test
  def setup
    # @server = Server.new
    # @server.start
    request_lines = 	["GET / HTTP/1.1",
	 "Host: 127.0.0.1:9292",
	 "Connection: keep-alive",
   "Content-Length: 148",
	 "Cache-Control: no-cache",
	 "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
	 "Postman-Token: 2fa75e50-0280-3605-1ed9-49e9790972f9",
	 "Accept: */*",
	 "Accept-Encoding: gzip, deflate, sdch, br",
   "Accept-Language: en-US,en;q=0.8"]
    @extract = Extract.new(request_lines)

  end
 
 
  def test_extract_can_split
    split = @extract.split
    assert_equal "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost:  127.0.0.1\nPort: 9292\nOrigin:  127.0.0.1\nAccept: */*", split
  end

  def test_can_return_verb
    verb = @extract.verb
    assert_equal "GET", verb
  end

  def test_can_return_path
    path = @extract.path
    assert_equal "/", path
  end

  def test_can_return_content_length
    content_length = @extract.content_length
    assert_equal 148, content_length
  end
 
end
  #  binding.pry
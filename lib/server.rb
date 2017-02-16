require 'socket'
require 'time'
require 'pry'
require './lib/game'
require './lib/extract'
# require './lib/path'


class Server 
  attr_reader :counter, :requests, :quit, :game, :content_length, :client 

  attr_accessor :path, :word, :verb

  def initialize
    @requests = 0
    @counter = 0
    @quit = false
  end

  def start
    tcp_server = TCPServer.new(9292)
    until quit
      @client = tcp_server.accept
      request_lines = []
      
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp 
      end    

      extracted = extract_request(request_lines)

      read_guess
      output(extracted)
    end
  end

  def read_guess
    if path == "/game" && verb == "POST"
      guessed_number = client.read(content_length)
      guessed_number = guessed_number.split("=")[1].to_i
      @game.guess(guessed_number).to_s
    end
  end


  def output(extracted)
    response = respond
    response += "<pre>" + extracted + "<pre/>" unless response.nil?
    output = "<html><head><link rel='shortcut icon' href='about:blank'></head><body>#{response}</body></html>"
    headers = create_headers(output.length)
    client.puts headers
    client.puts output
    client.close
  end



  def create_headers(length)
    headers = ["http/1.1 200 ok",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{length}\r\n\r\n"]

    if verb == "POST" && path.start_with?("/game") 
      headers[0] = "http/1.1 302"
      headers.insert(1, "location: http://127.0.0.1:9292/game")
    end
    headers.join("\r\n")
  end

  def check_word
    got_word = @word
    file = File.read('./data/dictionary.txt')
    file = file.split("\n")
    if file.include?(got_word)
      return "#{got_word} is a known word"
    else
      return "#{got_word} is not a known word"
    end
  end

  def respond
    @requests += 1
    if path ==  "/"
      ""
    elsif path == "/hello"
      say_hello
    elsif path == "/datetime"
      DateTime.now.strftime('%l:%M%p on %A, %b %e, %Y')
    elsif path == "/shutdown"
      @quit = true
      "Total Requests #{requests}"
    elsif path == "/word_search"
      check_word
   elsif path == "/start_game" && verb == "POST"
      @game = Game.new
      "Good Luck!"
   elsif verb == "GET" && path == "/game"
     answer = @game.info
    end
  end


  def say_hello
    @counter += 1
    "Hello World (#{counter})"
  end

  def extract_request(request_lines)
    extract = Extract.new(request_lines)
    @verb = extract.verb
    @path = extract.path
    @content_length = extract.content_length
    @word = extract.word if path == "/word_search"
    extract.split
  end

end

server = Server.new
server.start
# binding.pry


""
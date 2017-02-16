require 'socket'
require 'time'
require 'pry'
require './lib/game'


class Server 
  attr_accessor :counter, :requests, :path, :quit, :verb, :game, :content_length, :body

  def initialize
    @counter = 0
    @requests = 0
    @path = ""
    @quit = false
    @verb = ""
    @game = ""
    @content_length = 0
    @body = ""
  end


  def start
    tcp_server = TCPServer.new(9292)
    
    while true
      break if quit == true
      client = tcp_server.accept
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp 
      end    
      debug = extract_request(request_lines)
      # binding.pry

      # This is the body...?
      # @body = client.read(content_length)
      # @body = body.lines[3].chomp ?????
      
      response = respond 
      # binding.pry
      response += "<pre>" + debug + "<pre/>" unless response.nil?
      output = "<html><head><link rel='shortcut icon' href='about:blank'></head><body>#{response}</body></html>"
      client.puts output
      client.close
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
      "Total Requests #{@requests}"
    elsif path.start_with?("/word_search")
      check_word

    #You'll want to grab these out into their own method. game_response?
    elsif path == "/start_game" && verb == "POST"
      #set to an instance? @game?
      @game = Game.new
      "Good Luck!"
    elsif path.start_with?("/game") 
      #make all path.split("?")..s into a get_parameter method?
      # guess = path.split("?")[1].split("=")[1]
      if verb == "GET"
        #game.info ?
        @game.info
      elsif verb == "POST"
        guessed_number = path.split("=")[1].to_i
        # binding.pry
        @game.guess(guessed_number).to_s
      end
    end

  end

  def say_hello
    @counter += 1
    "Hello World (#{counter})"
  end

  def check_word
    word = path.split("?")[1].split("=")[1]
    # word = word.split("=")[1]
    file = File.read('./data/dictionary.txt')
    #Comment out next line if word should be a fragment
    file = file.split("\n")
    if file.include?(word)
      return "#{word} is a known word"
    else
      return "#{word} is not a known word"
    end
  end


  def extract_request(request_lines)
    # binding.pry
    first_line = request_lines.first.split(" ")
    second_line = request_lines[1].split(":")
    fourth_line = request_lines[3].split(" ")

    @verb = first_line[0]
    @path = first_line[1]
    protocol = first_line[2]
    host = second_line[1]
    port = second_line[2]
    accept = request_lines.find{|line| line.start_with?("Accept:")}
    @content_length = fourth_line[1].to_i

    # origin = request_lines.find{|line| line.start_with?("Origin:")}
    "Verb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{host}\n#{accept}"
  end


  def find_content_length
        content_length = request_lines.find{|line| line.start_with?("Content-Length:")}
  end


  def new_game
    game = Game.new
  end

end

server = Server.new
server.start

# server.check_word("cow")
# binding.pry
""
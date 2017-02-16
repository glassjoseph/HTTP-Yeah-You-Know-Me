require 'socket'
require 'time'
require 'pry'
# require './lib/game'
require './lib/path'


class Server 
  attr_reader :counter, :requests, :path, :quit, :verb, :game, :content_length, :client

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
      path_obj = Path.new
      
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp 
      end    

      debug = extract_request(request_lines)
      
      response = path_obj.respond(path, verb)
      # @requests += 1
      
      response += "<pre>" + debug + "<pre/>" unless response.nil?
      path_obj.read_body
      output(response)
    end
  end

  # def read_body
  #   if path == "/game" && verb == "POST"
  #     guessed_number = client.read(content_length)
  #     guessed_number = guessed_number.split("=")[1].to_i
  #     @game.guess(guessed_number).to_s
  #   end
  # end


  def output(response)

    output = "<html><head><link rel='shortcut icon' href='about:blank'></head><body>#{response}</body></html>"
    headers = create_headers(output.length)
    client.puts headers
    client.puts output
    client.close
  end



  def create_headers(length)
    #127.0.0.1:9292/game
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
    



  # def respond
  #   @requests += 1
  #   if path ==  "/"
  #     ""
  #   elsif path == "/hello"
  #     say_hello
  #   elsif path == "/datetime"
  #     DateTime.now.strftime('%l:%M%p on %A, %b %e, %Y')
  #   elsif path == "/shutdown"
  #     @quit = true
  #     "Total Requests #{@requests}"
  #   elsif path.start_with?("/word_search")
  #     check_word
  #  elsif path == "/start_game" && verb == "POST"
  #     @game = Game.new
  #     "Good Luck!"
  #  elsif verb == "GET" && path == "/game"
  #    answer = @game.info
  #   end
    

  # end




  def extract_request(request_lines)
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
    "Verb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{host}\n#{accept}"
  end

end

server = Server.new
binding.pry
server.start

# server.check_word
""

  # def find_content_length
  #   content_length = request_lines.find{|line| line.start_with?("Content-Length:")}
  # end


    # origin = request_lines.find{|line| line.start_with?("Origin:")}

  # def new_game
  #   game = Game.new
  # end
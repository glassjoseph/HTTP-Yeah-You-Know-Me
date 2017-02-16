require "./lib/game"

class Path
  attr_reader :path, :verb, :requests
  attr_accessor :counter
  
  def initialize(path, verb)
    @path = path
    @verb = verb
    @requests = 0
    @counter = 0
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
    elsif path.start_with?("/word_search")
      check_word
   elsif path == "/start_game" && verb == "POST"
      @game = Game.new
      "Good Luck!"
   elsif verb == "GET" && path == "/game"
     answer = @game.info
    end
  end



    def read_body
      if path == "/game" && verb == "POST"
        guessed_number = client.read(content_length)
        guessed_number = guessed_number.split("=")[1].to_i
        @game.guess(guessed_number).to_s
      end
    end
    

  def say_hello
    @counter += 1
    "Hello World (#{counter})"
  end

  def check_word
    word = path.split("?")[1].split("=")[1]
    file = File.read('./data/dictionary.txt')
    file = file.split("\n")
    if file.include?(word)
      return "#{word} is a known word"
    else
      return "#{word} is not a known word"
    end
  end


end
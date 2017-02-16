class Extract
attr_reader :request_lines

  def initialize(request_lines)
    @request_lines = request_lines
  end

  def split
    first_line = request_lines.first.split(" ")
    second_line = request_lines[1].split(":")
    got_verb = verb
    got_path = path
    protocol = first_line[2]
    host = second_line[1]
    port = second_line[2]
    accept = request_lines.find{|line| line.start_with?("Accept:")}
    "Verb: #{got_verb}\nPath: #{got_path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{host}\n#{accept}"
  end

  def verb
    request_lines.first.split(" ")[0]
  end

  def path 
    request_lines.first.split(" ")[1]
  end

  def content_length
    request_lines[3].split(" ")[1].to_i
  end

end
require "./gen_server/*"

module GenServer
  class OTP(T)
    def initialize(@value : T)
      @channel = Channel(T).new
      @mailbox = [] of String
      @state = [] of Int32
      init()
    end

    def init
      spawn do
        loop do
          value = @channel.receive
          handle_call(value)
        end
      end
    end

    def send(message, from)
      @channel.send(message)
    end

    def send_async(message)
      spawn do
        @channel.send(message)
      end
    end

    def handle_call(message : Int32)
      puts "I am a number #{messge}"
      {:ok, @state}
    end

    def handle_call(message : String)
      puts "I am a string #{messge}"
      {:ok, @state}
    end

    def handle_call(message)
      puts "I am a #{message}"
      {:ok, @state}
    end
  end
end

class Foo
  def initialize
    @pid = GenServer::OTP({Int32, String}).new({0, ""})
  end

  def send(message, from = self)
    @pid.send(message, from)
  end

  def send_async(message)
    @pid.send(message, self)
  end
end

f = Foo.new
f.send({1, "hello"})
f.send_async({2, "async"})
f.send({3, "bye"})

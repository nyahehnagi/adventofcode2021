class HelloWorld
    attr_reader :message
    
    def initialize
        @message = "Hello World!"
    end

    def say_hello
        return @message
    end
end
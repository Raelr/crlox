module CrLox
  class RuntimeException < Exception
    getter token
    @token : Token

    def initialize(token : Token, message : String)
      super("RuntimeException: #{message}")
      @token = token
    end
  end

  class InterpreterException < Exception
  end
end

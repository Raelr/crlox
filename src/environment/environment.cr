require "../token/*"
require "../interpreter/interpreter_errors"

module CrLox
  enum LiteralState
    NONE
  end

  class Environment
    getter values, enclosing

    def initialize(@enclosing : Environment?, @values = Hash(String, LiteralType | LiteralState).new)
    end

    def define(name : String, value : LiteralType | LiteralState)
      @values[name] = value
    end

    def get(name : Token) : LiteralType
      if @values.has_key?(name.lexeme)
        raise(RuntimeException.new(name, "Variable '#{name.lexeme}' has been declared but \
                                          has not been initialised!")) if @values[name.lexeme] == LiteralState::NONE
        return @values[name.lexeme].as(LiteralType)
      end
      return enclosing.as(Environment).get(name) unless @enclosing.nil?
      raise(RuntimeException.new(name, "Undefined Variable '#{name.lexeme}'."))
    end

    def assign(name : Token, value : LiteralType)
      if @values.has_key?(name.lexeme)
        @values[name.lexeme] = value
        return
      end
      unless @enclosing.nil?
        @enclosing.as(Environment).assign(name, value)
        return
      end
      raise(RuntimeException.new(name, "Undefined variable '#{name.lexeme}'."))
    end
  end
end

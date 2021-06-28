require "../token/*"
require "../interpreter/interpreter_errors"

module CrLox
  class Environment
    getter values, enclosing

    def initialize(@enclosing : Environment?, @values = Hash(String, LiteralType).new)
    end

    def define(name : String, value : LiteralType)
      @values[name] = value
    end

    def get(name : Token) : LiteralType
      return @values[name.lexeme] if @values.has_key?(name.lexeme)
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

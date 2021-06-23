require "../token/*"
require "../tool/expr"
require "../helper/error_helper"

module CrLox
  class Parser
    include CrLox::Helper

    def initialize(tokens : Array(Token))
      @current = 0
      @tokens = tokens
    end

    def initialize
      initialize(Array(Token).new)
    end

    def parse_tokens(tokens : Array(Token)) : Expr
      initialize(tokens)
      expression
    end

    def expression : Expr
      expr = equality
      while match?([TokenType::COMMA])
        expr = equality
      end
      expr
    end

    def equality : Expr
      expr = comparison
      while match?([TokenType::BANG_EQUAL, TokenType::EQUAL_EQUAL])
        operator = previous
        right = comparison
        expr = Binary.new(expr, operator, right)
      end
      return expr
    end

    def comparison : Expr
      expr = term
      while match?([TokenType::GREATER, TokenType::GREATER_EQUAL, TokenType::LESS, TokenType::LESS_EQUAL])
        operator = previous
        right = term
        expr = Binary.new(expr, operator, right)
      end
      return expr
    end

    def term : Expr
      expr = factor
      while match?([TokenType::MINUS, TokenType::PLUS])
        operator = previous
        right = factor
        expr = Binary.new(expr, operator, right)
      end
      return expr
    end

    def factor : Expr
      expr = unary
      while match?([TokenType::SLASH, TokenType::STAR])
        operator = previous
        right = unary
        expr = Binary.new(expr, operator, right)
      end
      return expr
    end

    def unary : Expr
      if match?([TokenType::BANG, TokenType::MINUS])
        operator = previous
        right = unary()
        return Unary.new(operator, right)
      end
      return primary
    end

    def primary : Expr
      return Literal.new(true) if match?([TokenType::TRUE])
      return Literal.new(false) if match?([TokenType::FALSE])
      return Literal.new(nil) if match?([TokenType::NIL])
      return Literal.new(previous.literal) if match?([TokenType::NUMBER, TokenType::STRING])
      if match?([TokenType::LEFT_PAREN])
        expr = expression()
        consume(TokenType::RIGHT_PAREN, "Expected ')' after expression")
        return Grouping.new(expr)
      end
      raise error(peek, "Expected expression.")
    end

    def match?(types : Array(TokenType)) : Bool
      types.each do |type|
        if check?(type)
          advance()
          return true
        end
      end
      return false
    end

    def consume(type : TokenType, message : String) : Token
      return advance if check?(type)
      raise(error(peek, message))
    end

    def check?(type : TokenType) : Bool
      return false if at_end?
      peek.type == type
    end

    def advance : Token
      @current += 1 unless at_end?
      previous
    end

    def at_end? : Bool
      peek.type == TokenType::EOF
    end

    def peek : Token
      @tokens[@current]
    end

    def previous : Token
      @tokens[@current == 0 ? @current : @current - 1]
    end

    def error(message : String, token : Token) : ParseException
      Helper.error(token, message)
      ParseException.new
    end

    def synchronise
      advance
      while !at_end?
        return if previous.type == TokenType::SEMICOLON

        case peek.type
        when TokenType::CLASS, TokenType::FUN, TokenType::VAR,
             TokenType::FOR, TokenType::IF, TokenType::WHILE,
             TokenType::PRINT, TokenType::RETURN
          return
        end
        advance
      end
    end
  end

  class ParseException < Exception
  end
end

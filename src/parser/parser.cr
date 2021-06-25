require "../token/*"
require "../ast/expr"
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

      if match?([TokenType::QUESTION])
        expr = ternary_operator(expr)
      end
      expr
    end

    def equality : Expr
      get_expression([
        TokenType::BANG_EQUAL,
        TokenType::EQUAL_EQUAL,
      ], ->{ comparison })
    end

    def ternary_operator(expr : Expr) : Expr
      operator = previous
      next_expr = expression()
      consume(TokenType::COLON, "Expected : for ternary operator: [EXPRESSION] ? [VALUE] : [VALUE]")
      Binary.new(expr, operator, Binary.new(next_expr, previous, expression))
    end

    def comparison : Expr
      get_expression([
        TokenType::GREATER,
        TokenType::GREATER_EQUAL,
        TokenType::LESS,
        TokenType::LESS_EQUAL,
      ], ->{ term })
    end

    def term : Expr
      get_expression([
        TokenType::MINUS,
        TokenType::PLUS,
      ], ->{ factor })
    end

    def factor : Expr
      get_expression([
        TokenType::SLASH,
        TokenType::STAR,
      ], ->{ unary })
    end

    def unary : Expr
      if match?([TokenType::BANG, TokenType::MINUS])
        # Create binary expression with the given operator (previous),
        # and a unary operator
        return Unary.new(previous, unary())
      end
      return primary
    end

    def primary : Expr
      literal = get_literal
      return literal if literal
      if match?([TokenType::LEFT_PAREN])
        expr = expression()
        consume(TokenType::RIGHT_PAREN, "Expected ')' after expression")
        return Grouping.new(expr)
      end
      raise error(peek, "Expected expression.")
    end

    def get_literal : Literal | Nil
      match?([TokenType::TRUE]) ? Literal.new(true) : match?([TokenType::FALSE]) ? Literal.new(false) : match?([TokenType::NIL]) ? Literal.new(nil) : match?([TokenType::NUMBER, TokenType::STRING]) ? Literal.new(previous.literal) : nil
    end

    def get_expression(types : Array(TokenType), get_expr : Proc(Expr))
      expr = get_expr.call
      while match?(types)
        # Create a Binary expression with the current expression,
        # the previous token, and the next expression.
        expr = Binary.new(expr, previous, get_expr.call)
      end
      expr
    end

    def match?(types : Array(TokenType)) : Bool
      types.each do |type|
        if check?(type)
          advance
          return true
        end
      end
      false
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

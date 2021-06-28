require "../token/*"
require "../ast/*"
require "../helper/error_helper"

module CrLox
  class Parser
    include CrLox::Helper

    def initialize(tokens : Array(Token))
      @current = 0
      @tokens = tokens
      @had_error = false
      @error_message = "ERRORS ENCOUNTERED WHILE PARSING FILE:\n\n"
    end

    def initialize
      initialize(Array(Token).new)
    end

    def parse_tokens(tokens : Array(Token)) : Array(Stmt)
      initialize(tokens)
      statements = Array(Stmt).new

      while !at_end?
        decl = declaration
        statements << decl.as(Stmt) unless decl.nil?
      end

      raise(ParseException.new(@error_message)) if @had_error

      statements
    end

    def declaration : Stmt | Nil
      begin
        return var_declaration if match?([TokenType::VAR])
        return statement()
      rescue ex
        synchronise
        @had_error = true
        @error_message += "#{ex.message}\n"
        return nil
      end
    end

    def var_declaration
      name = consume(TokenType::IDENTIFIER, "Expected variable name.")

      initialiser = nil
      initialiser = expression if match?([TokenType::EQUAL])

      consume(TokenType::SEMICOLON, "Expected ';' after variable declaration")

      Var.new(name, initialiser)
    end

    def assignment : Expr
      expr : Expr = equality
      if match?([TokenType::EQUAL])
        equals = previous
        value = assignment
        if expr.is_a?(Variable)
          name = expr.name
          return Assign.new(name, value)
        end
        error(equals, "Invalid assignment target")
      end
      while match?([TokenType::COMMA])
        expr = assignment
      end
      if match?([TokenType::QUESTION])
        expr = ternary_operator(expr)
      end
      expr
    end

    def statement : Stmt
      return print_statement if match?([TokenType::PRINT])
      return Block.new(block) if match?([TokenType::LEFT_BRACE])
      return expression_statement
    end

    def block : Array(Stmt)
      statements = Array(Stmt).new
      while !check?(TokenType::RIGHT_BRACE) && !at_end?
        decl = declaration
        statements.push(decl.as(Stmt)) unless decl.nil?
      end
      consume(TokenType::RIGHT_BRACE, "Expect '}' after block.")
      return statements
    end

    def expression_statement : Stmt
      expr = expression
      consume(TokenType::SEMICOLON, "Expect ';' after value.")
      Expression.new(expr)
    end

    def print_statement : Stmt
      value = expression
      consume(TokenType::SEMICOLON, "Expect ';' after value.")
      Print.new(value)
    end

    def expression : Expr
      expr = assignment
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
        return Unary.new(previous, unary())
      end
      return primary
    end

    def primary : Expr
      literal = get_literal
      return literal if literal

      if match?([TokenType::IDENTIFIER])
        return Variable.new(previous)
      end

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
      raise(error(previous, message))
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

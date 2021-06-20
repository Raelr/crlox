require "../token/token"
require "../helper/error_helper"
require "./scanner_error"

module CrLox
  extend CrLox::Helper

  class Scanner
    def initialize(@source : String)
      @tokens = Array(Token).new
      @start = 0
      @current = 0
      @line = 1
      @errors = Array(String).new
      @had_error = false
    end

    def scan_tokens
      while !is_at_end
        @start = @current
        scan_token
      end
      @tokens.push Token.new(TokenType::EOF, "", nil, @line)
      @tokens
    end

    def is_at_end : Bool
      @current >= @source.size
    end

    def scan_token
      current_char : Char = advance()
      case current_char
      when '('
        add_token(TokenType::LEFT_PAREN)
      when ')'
        add_token(TokenType::RIGHT_PAREN)
      when '{'
        add_token(TokenType::LEFT_BRACE)
      when '}'
        add_token(TokenType::RIGHT_BRACE)
      when ','
        add_token(TokenType::COMMA)
      when '.'
        add_token(TokenType::DOT)
      when '-'
        add_token(TokenType::MINUS)
      when '+'
        add_token(TokenType::PLUS)
      when ';'
        add_token(TokenType::SEMICOLON)
      when '*'
        add_token(TokenType::STAR)
      when '\n'
        @line += 1
      when ' ', '\r', '\t'
      else
        @errors.push Helper.error(@line, "Unexpected Character: #{current_char}")
        @had_error = true
      end
    end

    def advance : Char
      char = @current
      @current += 1
      @source.char_at(char)
    end

    def add_token(type : TokenType)
      add_token(type, nil)
    end

    def add_token(type : TokenType, literal : Literal | Nil)
      text : String = @source[@start...@current]
      @tokens.push(Token.new(type, text, literal, @line))
    end

    def had_error
      @had_error
    end

    def scanner_errors
      @errors
    end
  end
end

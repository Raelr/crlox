require "../token/token"
require "../helper/error_helper"
require "./scanner_error"
require "../helper/char_helper"

module CrLox
  class Scanner
    include CrLox::Helper

    @@keywords = {
      and:    TokenType::AND,
      class:  TokenType::CLASS,
      else:   TokenType::ELSE,
      false:  TokenType::FALSE,
      for:    TokenType::FOR,
      fun:    TokenType::FUN,
      if:     TokenType::IF,
      nil:    TokenType::NIL,
      or:     TokenType::OR,
      print:  TokenType::PRINT,
      return: TokenType::RETURN,
      super:  TokenType::SUPER,
      this:   TokenType::THIS,
      true:   TokenType::TRUE,
      var:    TokenType::VAR,
      while:  TokenType::WHILE,
    }

    def initialize(@source : String)
      @tokens = Array(Token).new
      @start = 0
      @current = 0
      @line = 1
      @errors = Array(String).new
      @had_error = false
    end

    def scan_tokens : Array(Token)
      while !is_at_end
        @start = @current
        scan_token
      end
      @tokens.push Token.new(TokenType::EOF, "", nil, @line)
    end

    def is_at_end : Bool
      @current >= @source.size
    end

    def scan_token
      current_char : Char = advance()

      case current_char
      when '(' ; add_token(TokenType::LEFT_PAREN)
      when ')' ; add_token(TokenType::RIGHT_PAREN)
      when '{' ; add_token(TokenType::LEFT_BRACE)
      when '}' ; add_token(TokenType::RIGHT_BRACE)
      when ',' ; add_token(TokenType::COMMA)
      when '.' ; add_token(TokenType::DOT)
      when '-' ; add_token(TokenType::MINUS)
      when '+' ; add_token(TokenType::PLUS)
      when ';' ; add_token(TokenType::SEMICOLON)
      when '*' ; add_token(TokenType::STAR)
      when '\n'; @line += 1
      when ' ', '\r', '\t'
      when '!'; add_token(match?('=') ? TokenType::BANG_EQUAL : TokenType::BANG)
      when '='; add_token(match?('=') ? TokenType::EQUAL_EQUAL : TokenType::EQUAL)
      when '<'; add_token(match?('=') ? TokenType::LESS_EQUAL : TokenType::LESS)
      when '>'; add_token(match?('=') ? TokenType::GREATER_EQUAL : TokenType::GREATER)
      when '/'; slash
      when '"'; string
      else
        if digit?(current_char)
          number
        elsif alpha?(current_char)
          identifier
        else
          log_error "Unexpected Character: #{current_char}"
        end
      end
    end

    def advance : Char
      char = @current
      @current += 1
      @source.char_at(char)
    end

    def peek : Char
      return is_at_end ? '\0' : @source.char_at(@current)
    end

    def peek_next
      if @current + 1 >= @source.size
        return '\0'
      end
      @source.char_at @current + 1
    end

    def add_token(type : TokenType)
      add_token(type, nil)
    end

    def add_token(type : TokenType, literal : Literal | Nil)
      text : String = @source[@start...@current]
      @tokens.push(Token.new(type, text, literal, @line))
    end

    def match?(expected : Char) : Bool
      return false if is_at_end || (@source.char_at(@current) != expected)
      @current += 1
      return true
    end

    def slash
      if match?('/')
        while peek != '\n' && !is_at_end
          advance
        end
      else
        add_token(TokenType::SLASH)
      end
    end

    def string
      while peek != '"' && !is_at_end
        @line += 1 if peek == '\n'
        advance
      end
      if is_at_end
        log_error "Unterminated string."
        return
      end

      advance

      value = @source[@start + 1...@current - 1]
      add_token(TokenType::STRING, value)
    end

    def number
      while digit?(peek)
        advance
      end
      if peek == '.' && digit?(peek_next)
        advance
        while digit?(peek)
          advance
        end
      end
      add_token(TokenType::NUMBER, @source[@start...@current].to_f)
    end

    def identifier
      while alpha_neumeric?(peek)
        advance
      end

      type = @@keywords.fetch(@source[@start...@current], TokenType::IDENTIFIER)

      add_token(type)
    end

    def log_error(message : String)
      @errors.push error(@line, message)
      @had_error = true
    end

    def had_error
      @had_error
    end

    def scanner_errors
      @errors
    end
  end
end

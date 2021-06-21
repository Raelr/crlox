require "../token/token"
require "../helper/error_helper"
require "./scanner_keywords"
require "../helper/char_helper"

module CrLox
  class Scanner
    include CrLox::Helper
    extend CrLox

    @@keywords : Hash(String, TokenType) = get_keywords

    def initialize(@source : String)
      @tokens = Array(Token).new
      @start = 0
      @current = 0
      @line = 1
      @errors = Array(String).new
      @had_error = false
    end

    def scan_tokens : Array(Token)
      while !at_end?
        @start = @current
        scan_token
      end
      @tokens.push Token.new(TokenType::EOF, "", nil, @line)
    end

    def at_end? : Bool
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
      return at_end? ? '\0' : @source.char_at(@current)
    end

    def peek_next
      if @current + 1 >= @source.size
        return '\0'
      end
      @source.char_at @current + 1
    end

    def match?(expected : Char) : Bool
      return false if at_end? || (@source.char_at(@current) != expected)
      @current += 1
      return true
    end

    def add_token(type : TokenType)
      add_token(type, nil)
    end

    def add_token(type : TokenType, literal : Literal | Nil)
      text : String = @source[@start...@current]
      @tokens.push(Token.new(type, text, literal, @line))
    end

    def slash
      if match?('/')
        while peek != '\n' && !at_end?
          advance
        end
      elsif match?('*')
        parse_comment_block
      else
        add_token(TokenType::SLASH)
      end
    end

    def parse_comment_block
      while !at_end? && !end_of_comment?
        if match?('/') && match?('*')
          parse_comment_block
        end
        @line += 1 if peek = '\n'
      end
    end

    def end_of_comment? : Bool
      advance == '*' && match?('/')
    end

    def string
      while peek != '"' && !at_end?
        @line += 1 if peek == '\n'
        advance
      end
      if at_end?
        log_error "Unterminated string."
        return
      end

      advance

      value = @source[@start + 1...@current - 1]
      add_token(TokenType::STRING, value)
    end

    def number
      get_digits(peek)
      if peek == '.' && digit?(peek_next)
        advance
        get_digits(peek)
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

    def get_digits(char : Char)
      while digit?(char)
        advance
      end
    end

    def log_error(message : String)
      @errors.push error(@line, message)
      @had_error = true
    end

    def had_error
      @had_error
    end

    def errors
      @errors
    end
  end
end

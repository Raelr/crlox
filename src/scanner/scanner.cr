require "../token/token"
require "../helper/error_helper"
require "./scanner_keywords"
require "../helper/char_helper"

module CrLox
  class Scanner
    include CrLox::Helper
    extend CrLox

    @@keywords : Hash(String, TokenType) = get_keywords

    def initialize
      @source = ""
      @tokens = Array(Token).new
      @start = 0
      @current = 0
      @line = 1
      @errors = Array(String).new
      @had_error = false
    end

    def scan_tokens(source : String) : Array(Token)
      initialize
      @source = source
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
      when ':' ; add_token(TokenType::COLON)
      when '?' ; add_token(TokenType::QUESTION)
      when '\n'; @line += 1
      when '!' ; add_token(match?('=') ? TokenType::BANG_EQUAL : TokenType::BANG)
      when '=' ; add_token(match?('=') ? TokenType::EQUAL_EQUAL : TokenType::EQUAL)
      when '<' ; add_token(match?('=') ? TokenType::LESS_EQUAL : TokenType::LESS)
      when '>' ; add_token(match?('=') ? TokenType::GREATER_EQUAL : TokenType::GREATER)
      when '/' ; parse_slash
      when '"' ; parse_string
      when ' ', '\r', '\t'
      else parse_digit_or_alpha_chars current_char
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

    def add_token(type : TokenType, literal : LiteralType | Nil)
      text : String = @source[@start...@current]
      @tokens.push(Token.new(type, text, literal, @line))
    end

    def parse_digit_or_alpha_chars(char : Char)
      if digit?(char)
        parse_number
      elsif alpha?(char)
        parse_identifier
      else
        log_error "Unexpected Character: #{char}"
      end
    end

    def parse_slash
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

    # Comment block - any occurrence of '/* or */'
    def parse_comment_block
      while !at_end? && !end_of_comment?
        if match?('/') && match?('*')
          parse_comment_block
        end
        increment_newline_if_end
      end
      increment_newline_if_end
    end

    def end_of_comment? : Bool
      advance == '*' && match?('/')
    end

    def parse_string
      while peek != '"' && !at_end?
        increment_newline_if_end
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

    def parse_number
      get_digits
      if peek == '.' && digit?(peek_next)
        advance
        get_digits
      end
      add_token(TokenType::NUMBER, @source[@start...@current].to_f)
    end

    def parse_identifier
      while alpha_neumeric?(peek)
        advance
      end

      type = @@keywords.fetch(@source[@start...@current], TokenType::IDENTIFIER)

      add_token(type)
    end

    def get_digits
      while digit?(peek)
        advance
      end
    end

    def log_error(message : String)
      @errors.push error(@line, message)
      @had_error = true
    end

    def increment_newline_if_end
      @line += 1 if peek == '\n'
    end

    def had_error
      @had_error
    end

    def errors
      @errors
    end
  end
end

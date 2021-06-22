require "./token_type"

module CrLox
  alias LiteralType = (String | Char | Float64 | Bool | Nil)

  class Token
    def initialize(@type : TokenType, @lexeme : String, @literal : LiteralType | Nil, @line : Int32)
    end

    def line
      @line
    end

    def literal
      @literal
    end

    def lexeme
      @lexeme
    end

    def type
      @type
    end

    def to_s : String
      "#{@line}| #{@type} #{@lexeme} #{@literal} "
    end
  end
end

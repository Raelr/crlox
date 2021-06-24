require "./token_type"

module CrLox
  alias LiteralType = (String | Char | Float64 | Bool | Nil)

  class Token
    getter type, lexeme, literal, line

    def initialize(@type : TokenType, @lexeme : String, @literal : LiteralType | Nil, @line : Int32)
    end

    def to_s : String
      "#{@line}| #{@type} #{@lexeme} #{@literal} "
    end
  end
end

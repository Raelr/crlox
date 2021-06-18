require "./token_type"

module CrLox
  alias Literal = (String | Char | Float64 | Bool | Nil)

  property type, lexeme, literal, line

  class Token 
    def initialize(@type : TokenType, @lexeme : String, @literal : Literal | Nil, @line : Int32)
    end

    def to_s : String
      "#{@type} #{@lexeme} #{@literal}"
    end
  end
end
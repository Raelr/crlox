require "./token_type"

module CrLox
  alias Literal = (String | Char | Float64 | Bool | Nil)

  class Token
    def initialize(@type : TokenType, @lexeme : String, @literal : Literal | Nil, @line : Int32)
    end

    def type
      @type
    end

    def to_s : String
      "#{@line}| #{@type} #{@lexeme} #{@literal} "
    end
  end
end

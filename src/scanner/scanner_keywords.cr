require "../token/token_type"

module CrLox
  def get_keywords : Hash(String, TokenType)
    return {
      "and"    => TokenType::AND,
      "class"  => TokenType::CLASS,
      "else"   => TokenType::ELSE,
      "false"  => TokenType::FALSE,
      "for"    => TokenType::FOR,
      "fun"    => TokenType::FUN,
      "if"     => TokenType::IF,
      "nil"    => TokenType::NIL,
      "or"     => TokenType::OR,
      "print"  => TokenType::PRINT,
      "return" => TokenType::RETURN,
      "super"  => TokenType::SUPER,
      "this"   => TokenType::THIS,
      "true"   => TokenType::TRUE,
      "var"    => TokenType::VAR,
      "while"  => TokenType::WHILE,
      "break"  => TokenType::BREAK,
    }
  end
end

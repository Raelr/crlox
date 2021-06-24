require "../interpreter/*"

module CrLox::Helper
  def error(line : Int32, message : String) : String
    report(line, "", message)
  end

  def error(token : Token, message : String) : String
    if token.type == TokenType::EOF
      report(token.line, " at end", message)
    else
      report(token.line, " at '" + token.lexeme + "'", message)
    end
  end

  def runtime_error(error : RuntimeException)
    "#{error.message}\n[line #{error.token.line}]"
  end

  def report(line : Int32, where : String, message : String) : String
    "Error: #{message}\n       Found in #{where}, line: #{line}"
  end
end

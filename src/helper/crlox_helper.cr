require "./error_helper"
require "../parser/parser"
require "../scanner/scanner"
require "../scanner/scanner_error"
require "../interpreter/*"
require "../ast/expr"
require "../tool/ast_printer"

module CrLox::Helper
  extend CrLox

  def get_source_from_file(path : String)
    File.read(path)
  end

  def run(source : String) : String
    scanner = Scanner.new
    parser = Parser.new
    interpreter = Interpreter.new

    tokens = scanner.scan_tokens(source)

    compiler_output = "Generated tokens:\n\n"
    tokens.each do |token|
      compiler_output += token.to_s + '\n'
    end

    expression = parser.parse_tokens(tokens)

    compiler_output += "\nExpanded Expression:\n\n" + CrLox.get_expanded_expression(expression) + "\n\n"

    compiler_output += "OUTPUT: #{interpreter.interpret(expression)}\n"
  end
end

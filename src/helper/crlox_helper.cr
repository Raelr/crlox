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

  def run(source : String)
    scanner = Scanner.new
    parser = Parser.new
    interpreter = Interpreter.new

    tokens = scanner.scan_tokens(source)

    statements = parser.parse(tokens)

    interpreter.interpret(statements)
  end
end

require "./error_helper"
require "../parser/parser"
require "../scanner/scanner"
require "../scanner/scanner_error"
require "../interpreter/*"
require "../tool/expr"
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
    check_scanner_errors(scanner, scanner.had_error)
    compiler_output = "Generated tokens:\n\n"
    tokens.each do |token|
      compiler_output += token.to_s + '\n'
    end
    expression = parser.parse_tokens(tokens)
    interpreter.interpret(expression)
    compiler_output += "\nExpanded Expression:\n\n" + CrLox.get_expanded_expression(expression)
  end

  def check_scanner_errors(scanner : Scanner, has_error : Bool)
    error_str = ""
    if has_error
      errors = scanner.errors
      errors.each do |error|
        error_str += "#{error}\n"
      end
      raise(ScannerException.new(error_str))
    end
  end
end

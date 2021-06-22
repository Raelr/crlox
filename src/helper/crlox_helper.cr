require "./error_helper"
require "../scanner/scanner"
require "../scanner/scanner_error"

module CrLox::Helper
  def get_source_from_file(path : String)
    File.read(path)
  end

  def run(source : String) : String
    scanner = Scanner.new
    tokens : Array(Token) = scanner.scan_tokens(source)
    check_scanner_errors(scanner, scanner.had_error)
    token_str = ""
    tokens.each do |token|
      token_str += token.to_s + '\n'
    end
    token_str
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

require "./error_helper"
require "../scanner/scanner"
require "../scanner/scanner_error"

module CrLox::Helper
  def run_file(path : String)
    run(File.read(path))
  end

  def run(source : String)
    scanner = Scanner.new(source)
    tokens : Array(Token) = scanner.scan_tokens
    check_scanner_errors(scanner, scanner.had_error)
    tokens.each do |token|
      puts token.to_s
    end
  end

  def check_scanner_errors(scanner : Scanner, has_error : Bool)
    if has_error
      errors = scanner.errors
      errors.each do |error|
        puts error
      end
      raise(ScannerException.new)
    end
  end
end

require "./error_helper"
require "../scanner/scanner"
require "../scanner/scanner_error"

module CrLox::Helper
  def self.run_file(path : String)
    run(File.read(path))
  end

  def self.run(source : String)
    scanner = Scanner.new(source)
    tokens : Array(Token) = scanner.scan_tokens
    check_scanner_errors(scanner, scanner.had_error)
    tokens.each do |token|
      puts token.to_s
    end
  end

  def self.check_scanner_errors(scanner : Scanner, has_error : Bool)
    if has_error
      errors = scanner.scanner_errors
      errors.each do |error|
        puts error
      end
      raise(UnRecognisedTokenException.new)
    end
  end
end

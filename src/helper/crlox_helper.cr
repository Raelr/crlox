require "./error_helper"
require "../scanner/scanner"

module CrLox::Helper
  
  def self.run_file(path : String)
    run(File.read(path))
  end

  def self.run(source : String)
    puts source
    scanner = Scanner.new(source)
    tokens : Array(Token) = scanner.scan_tokens

    tokens.each do |token| 
      puts token.to_s
    end
  end
end
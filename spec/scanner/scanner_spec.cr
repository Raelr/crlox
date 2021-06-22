require "../../src/scanner/*"
require "../../src/token/token_type"

include CrLox

src = "var language = \"lox\";"
src_with_comment = "// This creates a string called 'lox'\n#{src}"
src_with_multi_line_comment = "/*\nThis is a multi-\nline comment\n*/#{src}"
src_with_nested_multi_line_comment = "/*\n/*\nThis is an inner comment\n*/This is an outer comment\n*/"
src_with_undefined_char = "var lox = ?"
src_with_unclosed_string = "var language = \"lox;"

expectedTokens = [
  TokenType::VAR,
  TokenType::IDENTIFIER,
  TokenType::EQUAL,
  TokenType::STRING,
  TokenType::SEMICOLON,
  TokenType::EOF,
]

expectedTokenCount = 6

describe CrLox::Scanner do
  scanner = Scanner.new
  describe "parse string and return token counts" do
    scanner.scan_tokens(src).size.should eq expectedTokenCount
  end
  describe "parse string and return correct tokens" do
    tokens = scanner.scan_tokens(src)
    (0...expectedTokenCount).each do |idx|
      tokens[idx].type.should eq expectedTokens[idx]
    end
  end

  describe "parse string and ignore single, multi, and nested multi line comments" do
    scanner.scan_tokens(src_with_comment).size.should eq expectedTokenCount
    scanner.scan_tokens(src_with_multi_line_comment).size.should eq expectedTokenCount
    scanner.scan_tokens(src_with_nested_multi_line_comment).size.should eq 1
  end
  describe "parse string and ignore multi-line comment" do
    tokens = scanner.scan_tokens(src_with_comment)
    tokens.size.should eq expectedTokenCount
  end
  describe "parse nested multi-line comment" do
    tokens = scanner.scan_tokens(src_with_nested_multi_line_comment)
    tokens.size.should eq 1
  end
  describe "parse faulty string and return error" do
    scanner.scan_tokens(src_with_undefined_char)
    scanner.had_error.should eq true
    scanner.errors[0].should eq "Error: Unexpected Character: ?\n       Found in , line: 1"
  end
  describe "parse soure with unclosed string and return error" do
    scanner.scan_tokens(src_with_unclosed_string)
    scanner.had_error.should eq true
    scanner.errors[0].should eq "Error: Unterminated string.\n       Found in , line: 1"
  end
end

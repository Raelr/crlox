require "../../src/parser/*"
require "../../src/tool/ast_printer"

include CrLox

def get_expressions(src : String, scanner : Scanner, parser : Parser) : Expr
  tokens = scanner.scan_tokens(src)
  expression = parser.parse_tokens(tokens)
end

describe CrLox::Parser do
  printer = AstPrinter.new
  parser = Parser.new
  scanner = Scanner.new
  describe "it should be able to create a parser" do
    testParser = Parser.new
    testParser.should_not eq nil
  end
  describe "it should return the correct expression" do
    expression = get_expressions("5 + 2", scanner, parser)
    CrLox.get_expanded_expression(expression).should eq "( + 5.0 2.0)"
  end
  describe "it should return the correct expression with multiple operations" do
    expression = get_expressions("5 + 3 * 2 / 6", scanner, parser)
    CrLox.get_expanded_expression(expression).should eq "( + 5.0 ( / ( * 3.0 2.0) 6.0))"
  end
  describe "it should return the correct expression with brackets and operations" do
    expression = get_expressions("5 + 3 * (2 / 6)", scanner, parser)
    CrLox.get_expanded_expression(expression).should eq "( + 5.0 ( * 3.0 ( group ( / 2.0 6.0))))"
  end
  describe "it should correctly return a ternary operator expression" do
    expression = get_expressions("true ? 5 : 0", scanner, parser)
    CrLox.get_expanded_expression(expression).should eq "( ? true ( : 5.0 0.0))"
  end
  describe "it should correctly return a comma operator expression" do
    expression = get_expressions("5 + 2, 8 - 3, 7 / 2", scanner, parser)
    CrLox.get_expanded_expression(expression).should eq "( / 7.0 2.0)"
  end
  describe "it should raise an error when sending a string with an unterminated bracket" do
    expect_raises(Exception) do
      get_expressions("5 + (3 / 1", scanner, parser)
    end
  end
  describe "it should raise an error when sending a string with an expected expression" do
    expect_raises(Exception) do
      get_expressions("5 +", scanner, parser)
    end
  end
end

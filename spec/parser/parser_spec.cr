require "../../src/parser/*"
require "../../src/tool/ast_printer"

include CrLox

def get_expressions(src : String, scanner : Scanner, parser : Parser) : Array(Stmt)
  tokens = scanner.scan_tokens(src)
  statements = parser.parse(tokens)
end

def verify_var_has_values(statement : Var, lexeme : String, literal_value : LiteralType, type : TokenType)
  statement.name.type.should eq TokenType::IDENTIFIER
  statement.name.lexeme.should eq lexeme
  statement.initialiser.is_a?(Literal).should eq true
  statement.initialiser.as(Literal).value.should eq 10
end

describe CrLox::Parser do
  parser = Parser.new
  scanner = Scanner.new
  describe "it should be able to create a parser" do
    testParser = Parser.new
    testParser.should_not eq nil
  end
  describe "it should parse a variable declaration statement correctly" do
    statements = get_expressions("var a = 10;", scanner, parser)
    statements[0].is_a?(Var).should eq true
    verify_var_has_values(statements[0].as(Var), "a", 10, TokenType::IDENTIFIER)
  end
  describe "it should parse a variable assignment declaration correctly" do
    statements = get_expressions("var a = 10;\nvar b = a + 5;", scanner, parser)

    statements[0].is_a?(Var).should eq true
    verify_var_has_values(statements[0].as(Var), "a", 10, TokenType::IDENTIFIER)

    statements[1].is_a?(Var).should eq true

    statement = statements[1].as(Var)
    statement.name.type.should eq TokenType::IDENTIFIER
    statement.name.lexeme.should eq "b"
    statement.initialiser.is_a?(Binary).should eq true

    binary = statement.initialiser.as(Binary)
    binary.left.is_a?(Variable).should eq true
    binary.right.is_a?(Literal).should eq true
    binary.right.as(Literal).value.should eq 5
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

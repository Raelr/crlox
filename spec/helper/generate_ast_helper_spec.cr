require "../../src/helper/generate_ast_helper"

TARGET_SOURCE = "module CrLox
  abstract class Expr
  end
  class Visitor(T)
    def visit_test_expr(expr : Test) : T
    end
  end

  class Test < Expr
    getter left, operator, right
    def initialize(@left : Expr, @operator : Token, @right : Expr)
    end
    def accept(visitor)
      visitor.visit_test_expr(self)
    end
  end
end"

include CrLox::Helper

describe CrLox::Helper do
  source = define_ast("expr", [
    "Test		: Expr left, Token operator, Expr right",
  ])
  empty_source = Array(String).new
  describe "it should generate an ast string" do
    source.should_not eq ""
  end
  describe "it should generate an ast string and verify that it is correct" do
    source.should eq TARGET_SOURCE
  end
  describe "it should generate an error when an empty type array is provided" do
    expect_raises(Exception) do
      empty_string = define_ast("expr", empty_source)
    end
  end
end

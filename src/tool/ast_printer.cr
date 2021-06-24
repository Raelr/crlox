require "./expr"
require "../token/*"

module CrLox
  extend CrLox

  PRINTER = AstPrinter.new

  class AstPrinter < Visitor(String)
    include CrLox

    def visit_binary_expr(expr : Binary) : String
      parenthesize(expr.operator.lexeme, [expr.left, expr.right])
    end

    def visit_grouping_expr(expr : Grouping) : String
      parenthesize("group", [expr.expression])
    end

    def visit_literal_expr(expr : Literal) : String
      return expr.value == nil ? "nil" : expr.value.to_s
    end

    def visit_unary_expr(expr : Unary) : String
      parenthesize(expr.operator.lexeme, [expr.right])
    end
  end

  def parenthesize(name : String, expressions : Array(Expr)) : String
    string = "( #{name}"
    expressions.each do |expr|
      string += " #{expr.accept(self)}"
    end
    string += ')'
  end

  def get_expanded_expression(expression : Expr) : String
    expression.accept(PRINTER)
  end
end

require "../tool/expr"
require "../token/*"
require "../helper/error_helper"
require "./interpreter_errors.cr"
require "../helper/interpreter_helper"

module CrLox
  extend CrLox

  class Interpreter < Visitor(LiteralType)
    include CrLox::Helper

    def initialize(@had_error : Bool = false, @error_message : String = "")
    end

    def interpret(expression : Expr) : String
      begin
        result = evaluate(expression)
      rescue ex : RuntimeException
        @had_error = true
        @error_message += "#{runtime_error(ex)}"
      end

      raise(InterpreterException.new(@error_message)) if @had_error
      stringify(result)
    end

    def visit_binary_expr(expr : Binary) : LiteralType
      left = evaluate(expr.left)
      right = evaluate(expr.right)

      case expr.operator.type
      when TokenType::GREATER
        verify_number_operands(expr.operator, left, right)
        return left.as(Float64) > right.as(Float64)
      when TokenType::GREATER_EQUAL
        verify_number_operands(expr.operator, left, right)
        return left.as(Float64) >= left.as(Float64)
      when TokenType::LESS
        verify_number_operands(expr.operator, left, right)
        return left.as(Float64) < right.as(Float64)
      when TokenType::LESS_EQUAL
        verify_number_operands(expr.operator, left, right)
        return left.as(Float64) <= right.as(Float64)
      when TokenType::BANG_EQUAL ; return !equal?(left, right)
      when TokenType::EQUAL_EQUAL; return equal?(left, right)
      when TokenType::MINUS
        verify_number_operands(expr.operator, left, right)
        return left.as(Float64) - right.as(Float64)
      when TokenType::SLASH
        verify_number_operands(expr.operator, left, right)
        log_runtime_error(expr.operator, "Cannot divide value by 0!") if right == 0
        return left.as(Float64) / right.as(Float64)
      when TokenType::STAR
        verify_number_operands(expr.operator, left, right)
        return left.as(Float64) * right.as(Float64)
      when TokenType::PLUS
        if left.is_a?(Float64) && right.is_a?(Float64)
          return left.as(Float64) + right.as(Float64)
        end
        if (left.is_a?(String) && right.is_a?(String)) || left.is_a?(String) && right.is_a?(Float64)
          return "#{left}#{right.is_a?(Float64) ? format_number(right) : right}"
        end
        log_runtime_error(expr.operator, "Operands must be two numbers or two strings.")
      end

      nil
    end

    def visit_grouping_expr(expr : Grouping) : LiteralType
      evaluate(expr.expression)
    end

    def visit_literal_expr(expr : Literal) : LiteralType
      return expr.value
    end

    def visit_unary_expr(expr : Unary) : LiteralType
      right = evaluate(expr.right)

      case expr.operator.type
      when TokenType::MINUS
        verify_number_operand(expr.operator, right)
        return -right.as(Float64)
      when TokenType::BANG; return !truthy?(right)
      end

      nil
    end

    def evaluate(expr : Expr) : LiteralType
      expr.accept(self)
    end
  end
end

require "../tool/expr"
require "../token/*"

module CrLox
  extend CrLox

  class Interpreter < Visitor(LiteralType)
    def visit_binary_expr(expr : Binary) : LiteralType
      left = evaluate(expr.left)
      right = evaluate(expr.right)

      case expr.operator.type
      when TokenType::GREATER
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) > right.as(Float64)
      when TokenType::GREATER_EQUAL
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) >= left.as(Float64)
      when TokenType::LESS
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) < right.as(Float64)
      when TokenType::LESS_EQUAL
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) <= right.as(Float64)
      when TokenType::BANG_EQUAL ; return !equal?(left, right)
      when TokenType::EQUAL_EQUAL; return equal?(left, right)
      when TokenType::MINUS
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) - right.as(Float64)
      when TokenType::SLASH
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) / right.as(Float64)
      when TokenType::STAR
        check_number_operands(expr.operator, left, right)
        return left.as(Float64) * right.as(Float64)
      when TokenType::PLUS
        if left.class == Float64 && right.class == Float64
          return left.as(Float64) + right.as(Float64)
        end
        if left.class == String && right.class == String
          return "#{left} #{right}"
        end
        raise(RuntimeException.new(expr.operator, "Operands must be two numbers or two strings."))
      end

      nil
    end

    def interpret(expression : Expr)
      puts stringify(evaluate(expression))
    end

    def stringify(object : LiteralType)
      return "nil" if object == nil
      if object.class == Float64
        return object.to_s
      end
      object.to_s
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
      when TokenType::MINUS; return -right.as(Float64)
      when TokenType::BANG ; return is_truthy?(right)
      end

      nil
    end

    def check_number_operand(operator : Token, operand : LiteralType)
      return if operand.class == Float64
      raise(RuntimeException.new(operator, "Operand must be a number."))
    end

    def check_number_operands(operator : Token, left : LiteralType, right : LiteralType)
      return if left.class == Float64 && right.class == Float64
      raise(RuntimeException.new(operator, "Operands mus be numbers."))
    end

    def is_truthy?(literal : LiteralType) : Bool
      return literal.as(Bool) if literal.class == Bool
      return !(literal == nil)
    end

    def equal?(left : LiteralType, right : LiteralType) : Bool
      return true if left == nil && right == nil
      return false if left == nil
      left == right
    end

    def evaluate(expr : Expr) : LiteralType
      expr.accept(self)
    end
  end

  class RuntimeException < Exception
    @token : Token

    def initialize(token : Token, message : String)
      super(message)
      @token = token
    end
  end
end

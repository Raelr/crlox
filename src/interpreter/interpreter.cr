require "../ast/*"
require "../token/*"
require "../helper/error_helper"
require "./interpreter_errors.cr"
require "../helper/interpreter_helper"
require "../environment/environment"

module CrLox
  extend CrLox

  class Interpreter < Visitor(LiteralType)
    include CrLox::Helper

    def initialize(
      @had_error : Bool = false,
      @error_message : String = "",
      @environment = Environment.new(nil),
      @break : Bool = false,
      @active_loops : Int32 = 0
    )
    end

    def interpret(statements : Array(Stmt))
      begin
        statements.each do |statement|
          execute(statement)
        end
      rescue ex : RuntimeException
        @had_error = true
        @error_message += "#{runtime_error(ex)}"
      end

      raise(InterpreterException.new(@error_message)) if @had_error
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

    def execute(stmt : Stmt)
      stmt.accept(self)
    end

    def visit_logical_expr(expr : Expr)
      left = evaluate(expr.left)
      type = expr.operator.type

      return left if (type == TokenType::OR && truthy?(left)) || !truthy?(left)

      evaluate(expr.right)
    end

    def visit_break_stmt(stmt : Stmt)
      log_runtime_error(stmt.name, "Cannot use 'break' outside of loop!") if @active_loops == 0
      @break = true
    end

    def visit_while_stmt(stmt : Stmt)
      @active_loops += 1

      while truthy?(evaluate(stmt.condition))
        if @break
          @break = false
          break
        end
        execute(stmt.body)
      end

      @active_loops -= 1
      nil
    end

    def visit_if_stmt(stmt : Stmt)
      is_true = truthy?(evaluate(stmt.condition))
      execute(stmt.then_branch) if is_true
      execute(stmt.else_branch.as(Stmt)) unless stmt.else_branch.nil? || is_true
      nil
    end

    def visit_assign_expr(expr : Expr)
      value = evaluate(expr.value)
      @environment.assign(expr.name, value)
      value
    end

    def visit_block_stmt(stmt : Stmt)
      execute_block(stmt.statements, Environment.new(@environment))
    end

    def visit_print_stmt(stmt : Stmt)
      value = evaluate(stmt.expression)
      puts stringify(value)
    end

    def visit_var_stmt(stmt : Stmt)
      value = stmt.initialiser ? evaluate(stmt.initialiser.as(Expr)) : LiteralState::NONE
      @environment.define(stmt.name.lexeme, value)
      nil
    end

    def visit_variable_expr(expr : Expr)
      @environment.get(expr.name)
    end

    def visit_expression_stmt(stmt : Stmt)
      evaluate(stmt.expression)
    end

    def visit_grouping_expr(expr : Grouping) : LiteralType
      evaluate(expr.expression)
    end

    def visit_literal_expr(expr : Literal) : LiteralType
      return expr.value
    end

    def visit_unary_expr(expr : Unary) : LiteralType
      right = evaluate(expr.right)
      type = expr.operator.type

      return -right.as(Float64) if type == TokenType::MINUS && verify_number_operand(expr.operator, right).nil?
      return !truthy?(right) if type == TokenType::BANG

      nil
    end

    def execute_block(statements : Array(Stmt), environment : Environment)
      previous = @environment
      @environment = environment

      statements.each do |statement|
        break if @break
        execute(statement)
      end

      @environment = previous
      nil
    end

    def evaluate(expr : Expr) : LiteralType
      expr.accept(self)
    end
  end
end

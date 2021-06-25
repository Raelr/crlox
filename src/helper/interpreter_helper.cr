require "../interpreter/interpreter_errors"
require "../token/*"

module CrLox::Helper
  def stringify(object : LiteralType)
    return "nil" if object == nil
    if object.is_a?(Float64)
      return format_number(object).to_s
    end
    object.to_s
  end

  def format_number(number : Float64) : Int32 | Float64
    number.to_i == number ? number.to_i : number
  end

  def equal?(left : LiteralType, right : LiteralType) : Bool
    left == right
  end

  def truthy?(literal : LiteralType) : Bool
    !!literal
  end

  def verify_number_operand(operator : Token, operand : LiteralType)
    return if operand.is_a?(Float64)
    log_runtime_error(operator, "Operand must be a number.")
  end

  def verify_number_operands(operator : Token, left : LiteralType, right : LiteralType)
    return if left.is_a?(Float64) && right.is_a?(Float64)
    log_runtime_error(operator, "Operands must be numbers.")
  end

  def log_runtime_error(operator : Token, message : String)
    raise(RuntimeException.new(operator, message))
  end
end

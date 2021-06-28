module CrLox
  abstract class Expr
  end
  class Visitor(T)
    def visit_assign_expr(expr : Assign) : T
    end
    def visit_binary_expr(expr : Binary) : T
    end
    def visit_grouping_expr(expr : Grouping) : T
    end
    def visit_literal_expr(expr : Literal) : T
    end
    def visit_logical_expr(expr : Logical) : T
    end
    def visit_unary_expr(expr : Unary) : T
    end
    def visit_variable_expr(expr : Variable) : T
    end
  end

  class Assign < Expr
    getter name, value
    def initialize(@name : Token, @value : Expr)
    end
    def accept(visitor)
      visitor.visit_assign_expr(self)
    end
  end
  class Binary < Expr
    getter left, operator, right
    def initialize(@left : Expr, @operator : Token, @right : Expr)
    end
    def accept(visitor)
      visitor.visit_binary_expr(self)
    end
  end
  class Grouping < Expr
    getter expression
    def initialize(@expression : Expr)
    end
    def accept(visitor)
      visitor.visit_grouping_expr(self)
    end
  end
  class Literal < Expr
    getter value
    def initialize(@value : LiteralType)
    end
    def accept(visitor)
      visitor.visit_literal_expr(self)
    end
  end
  class Logical < Expr
    getter left, operator, right
    def initialize(@left : Expr, @operator : Token, @right : Expr)
    end
    def accept(visitor)
      visitor.visit_logical_expr(self)
    end
  end
  class Unary < Expr
    getter operator, right
    def initialize(@operator : Token, @right : Expr)
    end
    def accept(visitor)
      visitor.visit_unary_expr(self)
    end
  end
  class Variable < Expr
    getter name
    def initialize(@name : Token)
    end
    def accept(visitor)
      visitor.visit_variable_expr(self)
    end
  end
end

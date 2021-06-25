module CrLox
  abstract class Stmt
  end

  class Visitor(T)
    def visit_expression_stmt(stmt : Expression) : T
    end

    def visit_print_stmt(stmt : Print) : T
    end
  end

  class Expression < Stmt
    getter expression

    def initialize(@expression : Expr)
    end

    def accept(visitor)
      visitor.visit_expression_stmt(self)
    end
  end

  class Print < Stmt
    getter expression

    def initialize(@expression : Expr)
    end

    def accept(visitor)
      visitor.visit_print_stmt(self)
    end
  end
end

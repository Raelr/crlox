module CrLox
  abstract class Stmt
  end
  class Visitor(T)
    def visit_block_stmt(stmt : Block) : T
    end
    def visit_expression_stmt(stmt : Expression) : T
    end
    def visit_print_stmt(stmt : Print) : T
    end
    def visit_var_stmt(stmt : Var) : T
    end
  end

  class Block < Stmt
    getter statements
    def initialize(@statements : Array(Stmt))
    end
    def accept(visitor)
      visitor.visit_block_stmt(self)
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
  class Var < Stmt
    getter name, initialiser
    def initialize(@name : Token, @initialiser : Expr?)
    end
    def accept(visitor)
      visitor.visit_var_stmt(self)
    end
  end
end

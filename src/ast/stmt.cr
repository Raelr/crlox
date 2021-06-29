module CrLox
  abstract class Stmt
  end
  class Visitor(T)
    def visit_block_stmt(stmt : Block) : T
    end
    def visit_expression_stmt(stmt : Expression) : T
    end
    def visit_if_stmt(stmt : If) : T
    end
    def visit_print_stmt(stmt : Print) : T
    end
    def visit_var_stmt(stmt : Var) : T
    end
    def visit_while_stmt(stmt : While) : T
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
  class If < Stmt
    getter condition, then_branch, else_branch
    def initialize(@condition : Expr, @then_branch : Stmt, @else_branch : Stmt?)
    end
    def accept(visitor)
      visitor.visit_if_stmt(self)
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
  class While < Stmt
    getter condition, body
    def initialize(@condition : Expr, @body : Stmt)
    end
    def accept(visitor)
      visitor.visit_while_stmt(self)
    end
  end
end

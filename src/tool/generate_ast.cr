require "../helper/generate_ast_helper"
require "file_utils"

POSTFIX        = ".cr"
BASE_EXPR_NAME = "expr"
BASE_STMT_NAME = "stmt"

module Tool
  extend CrLox::Helper
  output_dir = ""

  begin
    raise("Usage: generate_ast <output directory>") if ARGV.size > 1
    output_dir = ARGV.size == 0 ? "./src/ast" : ARGV[0]

    ast_source = define_ast(BASE_EXPR_NAME, [
      "Assign   : Token name, Expr value",
      "Binary		: Expr left, Token operator, Expr right",
      "Grouping	: Expr expression",
      "Literal	: LiteralType value",
      "Logical  : Expr left, Token operator, Expr right",
      "Unary		: Token operator, Expr right",
      "Variable : Token name",
    ])

    statements_source = define_ast(BASE_STMT_NAME, [
      "Block      : Array(Stmt) statements",
      "Expression : Expr expression",
      "If         : Expr condition, Stmt then_branch, Stmt? else_branch",
      "Print      : Expr expression",
      "Var        : Token name, Expr? initialiser",
      "While      : Expr condition, Stmt body",
    ])
  rescue ex
    STDERR.puts ex.message
    exit(1)
  end
  FileUtils.mkdir_p output_dir

  File.open("#{output_dir}/#{BASE_EXPR_NAME}#{POSTFIX}", "w", encoding: "UTF-8") do |file|
    file.puts ast_source
  end

  File.open("#{output_dir}/#{BASE_STMT_NAME}#{POSTFIX}", "w", encoding: "UTF-8") do |file|
    file.puts statements_source
  end
end

require "../helper/generate_ast_helper"

POSTFIX   = ".cr"
BASE_NAME = "expr"

module Tool
  extend CrLox::Helper
  output_dir = ""

  begin
    raise("Usage: generate_ast <output directory>") if ARGV.size > 1
    output_dir = ARGV.size == 0 ? "./src/tool" : ARGV[0]
    ast_source = define_ast(BASE_NAME, [
      "Binary		: Expr left, Token operator, Expr right",
      "Grouping	: Expr expression",
      "Literal	: LiteralType value",
      "Unary		: Token operator, Expr right",
    ])
  rescue ex
    STDERR.puts ex.message
    exit(1)
  end
  File.open("#{output_dir}/#{BASE_NAME}#{POSTFIX}", "w", encoding: "UTF-8") do |file|
    file.puts ast_source
  end
end

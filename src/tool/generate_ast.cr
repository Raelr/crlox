require "file_utils"

module Tool
  TAB_SPACING   = "  "
  INNER_SPACING = TAB_SPACING * 2

  def self.define_ast(output_dir : String, base_name : String, types : Array(String))
    path = output_dir + '/' + base_name + ".cr"
    FileUtils.mkdir_p output_dir
    File.open(path, "w", encoding: "UTF-8") do |file|
      file.puts "module CrLox"
      file.puts

      file.puts "#{TAB_SPACING}abstract class #{base_name.capitalize}"
      file.puts "#{TAB_SPACING}end"
      file.puts

      define_visitor(file, base_name, types)

      types.each_with_index do |type, index|
        class_name = type.split(':')[0].strip
        fields = type.split(':')[1].strip
        define_type(file, base_name, class_name, fields)
        file.puts if index != types.size - 1
      end
      file.puts "end"
    end
  end

  def self.define_type(writer, base_name : String, class_name : String, field_list : String)
    writer.puts "#{TAB_SPACING}class #{class_name} < #{base_name.capitalize}"

    name_str = ""
    field_str = ""

    field_list.split(',').each do |field|
      field_data = field.strip(' ').split(" ")
      name_str += "#{field_data[1]}, "
      field_str += "@#{field_data[1]} : #{field_data[0]}, "
    end

    writer.puts "#{INNER_SPACING}getter #{name_str.strip(", ")}\n\n"
    writer.puts "#{INNER_SPACING}def initialize(#{field_str.strip(", ")})"
    writer.puts "#{INNER_SPACING}end"
    writer.puts "#{INNER_SPACING}def accept(visitor)"
    writer.puts "#{INNER_SPACING + TAB_SPACING}visitor.visit_#{class_name.underscore}_#{base_name.underscore}(self)"
    writer.puts "#{INNER_SPACING}end"
    writer.puts "#{TAB_SPACING}end"
  end

  def self.define_visitor(writer, base_name : String, types : Array(String))
    writer.puts "#{TAB_SPACING}class Visitor(T)\n\n"
    methods = types.each_with_index do |type, index|
      name = type.split(':')[0].strip
      writer.puts "#{INNER_SPACING}def visit_#{name.underscore}_#{base_name}(#{base_name} : #{name}) : T"
      writer.puts "#{INNER_SPACING}end"
      writer.puts if index != types.size - 1
    end
    writer.puts "#{TAB_SPACING}end\n\n"
  end

  begin
    if ARGV.size != 1
      raise("Usage: generate_ast <output directory>")
    end
  rescue ex
    STDERR.puts ex.message
    exit(1)
  end
  output_dir = ARGV[0]
  define_ast(output_dir, "expr", [
    "Binary		: Expr left, Token operator, Expr right",
    "Grouping	: Expr expression",
    "Literal	: LiteralType value",
    "Unary		: Token operator, Expr right",
  ])
end

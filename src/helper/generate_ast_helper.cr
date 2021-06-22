module CrLox::Helper
  TAB_SPACING   = "  "
  INNER_SPACING = TAB_SPACING * 2
  POSTFIX       = ".cr"
  MODULE        = "CrLox"

  def define_ast(base_name : String, types : Array(String)) : String
    raise(Exception.new("Error: no types were added the the ast!")) if types.empty?
    return "module #{MODULE}\n" +
      format_abstract_class(base_name) +
      "#{define_visitor(base_name, types)}\n" +
      format_types(types, base_name) +
      "end"
  end

  def define_type(base_name : String, class_name : String, field_list : String) : String
    type_string = "#{TAB_SPACING}class #{class_name} < #{base_name.capitalize}\n"

    names, fields = format_init_fn_params(field_list)

    type_string += "#{format_init_fn(names, fields)}\n" +
                   "#{format_visitor_fn(class_name, base_name)}\n" +
                   "#{TAB_SPACING}end"
  end

  def define_visitor(base_name : String, types : Array(String)) : String
    visitor_string = "#{TAB_SPACING}class Visitor(T)\n"
    methods = types.each_with_index do |type, index|
      name = type.split(':')[0].strip
      visitor_string += "#{format_visit_fn(name.underscore, base_name)}\n"
    end
    visitor_string += "#{TAB_SPACING}end\n"
  end

  def format_init_fn_params(field_list : String) : Tuple(String, String)
    names = ""
    fields = ""

    field_list.split(',').each do |field|
      field_data = field.strip(' ').split(" ")
      names += "#{field_data[1]}, "
      fields += "@#{field_data[1]} : #{field_data[0]}, "
    end
    {names, fields}
  end

  def format_types(types : Array(String), base_name : String) : String
    types_string = ""
    types.each_with_index do |type, index|
      type_data = type.split(':')
      types_string += "#{define_type(base_name, type_data[0].strip, type_data[1].strip)}\n"
    end
    types_string
  end

  def format_abstract_class(base_name : String) : String
    "#{TAB_SPACING}abstract class #{base_name.capitalize}\n" +
      "#{TAB_SPACING}end\n"
  end

  def format_init_fn(names : String, fields : String) : String
    "#{INNER_SPACING}getter #{names.strip(", ")}\n" +
      "#{INNER_SPACING}def initialize(#{fields.strip(", ")})\n" +
      "#{INNER_SPACING}end"
  end

  def format_visitor_fn(class_name : String, base_name : String)
    "#{INNER_SPACING}def accept(visitor)\n" +
      "#{INNER_SPACING + TAB_SPACING}visitor.visit_#{class_name.underscore}_#{base_name.underscore}(self)\n" +
      "#{INNER_SPACING}end"
  end

  def format_visit_fn(name : String, base_name : String) : String
    "#{INNER_SPACING}def visit_#{name}_#{base_name}(#{base_name} : #{name.capitalize}) : T\n" +
      "#{INNER_SPACING}end"
  end
end

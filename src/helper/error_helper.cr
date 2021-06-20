module CrLox::Helper
  def error(line : Int32, message : String) : String
    report(line, "", message)
  end

  def report(line : Int32, where : String, message : String) : String
    "Error: #{message}\n\tFound in #{where}, line: #{line}"
  end
end

module CrLox::Helper
  def self.error(line : Int32, message : String) : String
      report(line, "", message)
  end
  def self.report(line : Int32, where : String, message : String) : String
      "Error: #{message}\n\tFound in #{where}, line: #{line}"
  end
end
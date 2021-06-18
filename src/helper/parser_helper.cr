module CrLox::Helper
  def self.get_path(args : Array(String) = ARGV) : String
    if (args.size > 1)
      raise(TooManyArgsException.new "Too many arguments added! Compiler requires only one arg [SCRIPT]")
    end
    return args.size == 1 ? args[0] : ""
  end

  class TooManyArgsException < Exception
  end
end
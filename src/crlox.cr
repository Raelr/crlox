require "./helper/parser_helper"
require "./helper/crlox_helper"

require "./crlox_interactive/crlox_interactive"

module CrLox::Main
  extend CrLox::Helper

  begin 
    path = Helper.get_path
    if path != ""
      Helper.run_file(path) 
    else 
      Interactive.run_prompt
    end
  rescue ex
    STDERR.puts ex.message
    STDERR.puts "Usage: crlox [SCRIPT] (where SCRIPT = script path)"
    exit(1)
  end
end
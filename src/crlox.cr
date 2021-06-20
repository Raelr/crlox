require "./helper/parser_helper"
require "./helper/crlox_helper"

require "./crlox_interactive/crlox_interactive"

module CrLox::Main
  extend CrLox::Helper
  extend CrLox::Interactive

  begin
    path = get_path
    if path != ""
      run_file(path)
    else
      run_prompt
    end
  rescue ex
    STDERR.puts ex.message
    exit(1)
  end
end

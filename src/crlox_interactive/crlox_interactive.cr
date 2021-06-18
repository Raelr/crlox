require "../helper/crlox_helper"

module CrLox::Interactive
  extend CrLox::Helper

  def self.run_prompt 
    puts "Running crlox in interactive mode:\n\n"  
    loop do 
      input = get_input
      if input == "" 
        break 
      end
      Helper.run(input)
    end
  end

  def self.get_input : String
    puts "Please insert some lox code below:\n"
      return input = gets.to_s
  end
end
require "spec"
require "../../src/helper/parser_helper.cr"

describe CrLox::Helper do 

  describe "gets a path from a manually inserted list of args" do
    baseArgs = ["src/test.lox"]
    path = CrLox::Helper.get_path baseArgs
    path.should eq "src/test.lox"
  end

  describe "raise error if too many args" do 
    baseArgs = ["src/test.lox", "blah"]
    expect_raises(CrLox::Helper::TooManyArgsException) do
      path = CrLox::Helper.get_path baseArgs
    end
  end

  describe "Returns empty string when no args are passed in" do 
    baseArgs = [] of String
    path = CrLox::Helper.get_path baseArgs
    path.should eq ""
  end
end
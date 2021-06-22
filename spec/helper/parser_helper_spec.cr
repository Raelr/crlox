require "../../src/helper/parser_helper"
include CrLox::Helper

describe CrLox::Helper do
  describe "gets a path from a manually inserted list of args" do
    baseArgs = ["src/test.lox"]
    path = get_path baseArgs
    path.should eq "src/test.lox"
  end

  describe "raise error if too many args" do
    baseArgs = ["src/test.lox", "blah"]
    expect_raises(TooManyArgsException) do
      path = get_path baseArgs
    end
  end

  describe "Returns empty string when no args are passed in" do
    baseArgs = [] of String
    path = get_path baseArgs
    path.should eq ""
  end
end

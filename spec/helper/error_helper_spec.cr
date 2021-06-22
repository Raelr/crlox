require "../../src/helper/error_helper"
include CrLox::Helper

describe CrLox::Helper do
  describe "throw an error and format it correctly" do
    err = error(0, "This is a test error")
    err.should eq "Error: This is a test error\n       Found in , line: 0"
  end
end

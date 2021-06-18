require "spec"
require "../../src/helper/error_helper"

describe CrLox::Helper do 
  describe "throw an error and format it correctly" do 
    err = CrLox::Helper.error(0, "This is a test error")
    err.should eq "Error: This is a test error\n\tFound in , line: 0"
  end
end
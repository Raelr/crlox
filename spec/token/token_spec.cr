require "spec"
require "../../src/token/token"

def init_test_token : CrLox::Token
  CrLox::Token.new(CrLox::TokenType::PLUS, "+", nil, 0)
end

describe CrLox::Token do
  describe "can successfully create token" do
    token = init_test_token
    token.should_not be_nil
  end
  describe "should successfully print the correct string" do
    token = init_test_token
    token.to_s.should eq "0| PLUS +  "
  end
end

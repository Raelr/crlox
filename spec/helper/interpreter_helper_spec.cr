require "../../src/helper/interpreter_helper"

include CrLox::Helper

describe CrLox::Helper do
  describe "Stringify" do
    describe "returns a string when provided with one" do
      stringify("hello").should eq "hello"
    end

    describe "returns a float when provided with a decimal number" do
      stringify(5.32).should eq "5.32"
    end

    describe "returns an int when provided with a whole decimal number" do
      stringify(5.0).should eq "5"
    end

    describe "returns nil when provided with a nil value" do
      stringify(nil).should eq "nil"
    end

    describe "returns true when provided with a true value" do
      stringify(true).should eq "true"
    end

    describe "returns an int when provided with a whole decimal number" do
      stringify(false).should eq "false"
    end
  end

  describe "return decimal as decimal" do
    describe "Format number as decimal" do
      format_number(5.32).should eq 5.32
    end

    describe "return decimal as int if value after decimal is zero" do
      format_number(5.0).should eq 5
    end
  end

  describe "equal?" do
    describe "should return true if both inputted values are nil" do
      equal?(nil, nil).should eq true
    end

    describe "should return false if one value is nil and the other is something else" do
      equal?(nil, 1).should eq false
      equal?(nil, "AAAAA").should eq false
      equal?(false, nil).should eq false
    end
  end

  describe "truthy?" do
    describe "should return true when receiving a true value" do
      truthy?(true).should eq true
    end

    describe "should return false when receiving a false value" do
      truthy?(false).should eq false
    end

    describe "should return false when receiving a nil value" do
      truthy?(nil).should eq false
    end
  end

  describe "verify operand" do
    describe "verify number operand" do
      correct_token = token = Token.new(TokenType::NUMBER, "5", 5, 1)
      incorrect_token = Token.new(TokenType::TRUE, "true", true, 1)

      describe "should accept a number token and not cause an error" do
        verify_number_operand(correct_token, 5)
      end

      describe "should cause an error on a non-number token" do
        expect_raises(RuntimeException) do
          verify_number_operand(incorrect_token, true)
        end
      end
    end

    describe "verify number operands" do
      token = Token.new(TokenType::PLUS, "+", "+", 1)

      describe "should accept two numbers for a plus operand without error" do
        verify_number_operands(token, 5, 2)
      end

      describe "should cause an error if one or both of the operands are not numbers" do
        expect_raises(RuntimeException) do
          verify_number_operands(token, true, 2)
          verify_number_operands(token, true, false)
        end
      end
    end
  end
  describe "lof runtime error" do
    describe "it should raise an error" do
      expect_raises(RuntimeException) do
        log_runtime_error(Token.new(TokenType::NUMBER, "4", 4, 1), "THIS IS A TEST ERROR")
      end
    end
  end
end

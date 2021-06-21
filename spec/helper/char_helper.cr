require "spec"
require "../../src/helper/char_helper"

include CrLox::Helper

describe CrLox::Helper do
  describe "it should detect if a character is alphaneumeric" do
    alpha_neumeric?('f').should eq true
    alpha_neumeric?('z').should eq true
    alpha_neumeric?('0').should eq true
    alpha_neumeric?('9').should eq true
  end
  describe "it should detect if a character is not alphaneumeric" do
    alpha_neumeric?(')').should eq false
    alpha_neumeric?('$').should eq false
    alpha_neumeric?('}').should eq false
    alpha_neumeric?('/').should eq false
  end
  describe "it should detect if a character is an alpha character" do
    alpha?('a').should eq true
  end
  describe "it should detect if a character is not an alpha character" do
    alpha?('0').should eq false
  end
  describe "it should detect if a character is a digit character" do
    digit?('0').should eq true
  end
  describe "it should detect if a character is not a digit character" do
    digit?('f').should eq false
  end
end

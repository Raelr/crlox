require "../../src/helper/crlox_helper"

include CrLox::Helper

src_path = "assets/test.lox"
src_string = "var lanugage = lox"
src_broken_string = "var lanugage = ?"
src_unterminated_string = "var lanugage = \"lox;"

describe CrLox::Helper do
  describe "run the scanner over a file and get the source" do
    get_source_from_file("assets/test.lox").empty?.should_not eq true
  end
  # describe "run scanner over a source string" do
  #  run(src_string).empty?.should_not eq true
  # end
  # describe "run scanner over string with unidentified error" do
  #  expect_raises(ScannerException) do
  #    run(src_broken_string)
  #  end
  # end
  # describe "run scanner over string with open string" do
  #  expect_raises(ScannerException) do
  #    run(src_unterminated_string)
  #  end
  # end
end

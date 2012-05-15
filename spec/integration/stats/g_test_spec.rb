require 'spec_helper'

describe "The results for a G Test test" do
  it "should correctly report significance when it exists" do
    ABFab.configure do
      define_test :g_test_test
    end

    create_test_results :g_test_test, true  => [502, 123],
                                      false => [495, 89]

    puts ABFab.tests[:g_test_test].results
  end
end

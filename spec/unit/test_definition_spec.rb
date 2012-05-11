require 'spec_helper'

describe "When configuring ABFab" do
  it "define_test should create a new test" do
    ABFab.configure do |config|
      config.define_test :my_test do |test|
        test.possibilities = [1, 2, 3]
      end
    end

    ABFab.tests.length.should == 1

    test = ABFab.tests.first

    test.name.should == :my_test
    test.possibilities.should == [1, 2, 3]
  end
end

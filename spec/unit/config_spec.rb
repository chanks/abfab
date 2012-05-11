require 'spec_helper'

describe "When configuring ABFab" do
  it "define_test should create a new test" do
    ABFab.configure do
      define_test :my_test do
        possibilities [1, 2, 3]
      end
    end

    ABFab.tests.length.should == 1

    test = ABFab.tests[:my_test]

    test.name.should == :my_test
    test.possibilities.should == [1, 2, 3]
  end

  it "ABFab.reset! should remove all tests" do
    ABFab.configure do
      define_test :my_test do
        possibilities [1, 2, 3]
      end
    end

    ABFab.tests.length.should == 1

    ABFab.reset!

    ABFab.tests.length.should == 0
  end
end

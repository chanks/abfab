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

  it "ABFab.define_test should reopen the same test if done twice" do
    ABFab.configure do
      define_test :my_test do
        possibilities [1, 2, 3]
      end
    end

    ABFab.tests[:my_test].possibilities.should == [1, 2, 3]

    ABFab.configure do
      define_test :my_test do
        possibilities [1, 2, 3, "cat!"]
      end
    end

    ABFab.tests[:my_test].possibilities.should == [1, 2, 3, "cat!"]
  end

  it "ABFab.config and .configure should work equally well" do
    ABFab.config.should == ABFab.configure
    ABFab.config.should == ABFab::Config.instance
  end
end

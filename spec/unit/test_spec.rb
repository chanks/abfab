require 'spec_helper'

describe ABFab::Test do
  before do
    ABFab.configure do
      define_test :test
    end
  end

  it "should have a specific hash that changes when it is modified" do
    test = ABFab.tests[:test]

    test.hash.should == "ba74a057ff3cdd4bec3c0f2ff181e60c"
    test.values [1, 2]
    test.hash.should == "9477efdc04402582e0a85fc54a304316"
  end

  it "should have its hash in its key" do
    ABFab.tests[:test].key_for(:blah).should == "ABFab:ba74a057ff3cdd4bec3c0f2ff181e60c:blah"
  end

  it "should be reachable by both string and symbol" do
    ABFab.tests[:test].should == ABFab.tests['test']
  end
end

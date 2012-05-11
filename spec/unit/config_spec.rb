require 'spec_helper'

describe "When configuring ABFab" do
  it "define_test should create a new test" do
    ABFab.configure do
      define_test :my_test do
        values [1, 2, 3]
      end
    end

    ABFab.tests.length.should == 1

    test = ABFab.tests[:my_test]

    test.name.should == :my_test
    test.values.should == [1, 2, 3]
  end

  it "ABFab.reset! should remove all tests and the Redis connection" do
    ABFab.configure do
      redis Redis.new

      define_test :my_test do
        values [1, 2, 3]
      end
    end

    ABFab.tests.length.should == 1

    ABFab.reset!

    ABFab.redis.should == nil
    ABFab.tests.length.should == 0
  end

  it "ABFab.define_test should reopen the same test if done twice" do
    ABFab.configure do
      define_test :my_test do
        values [1, 2, 3]
      end
    end

    ABFab.tests[:my_test].values.should == [1, 2, 3]

    ABFab.configure do
      define_test :my_test do
        values [1, 2, 3, "cat!"]
      end
    end

    ABFab.tests[:my_test].values.should == [1, 2, 3, "cat!"]
  end

  it "ABFab.config and .configure should work equally well" do
    ABFab.config.should == ABFab.configure
    ABFab.config.should == ABFab::Config.instance
  end

  it "a test without values should default to true and false" do
    ABFab.configure do
      define_test :boolean
    end

    ABFab.tests[:boolean].values.should == [true, false]
  end

  it "a test without values should default to true and false" do
    ABFab.configure do
      define_test :boolean
    end

    ABFab.tests[:boolean].values.should == [true, false]
  end

  it "a test with a simple integer given for values should use numbers between 1 and that number" do
    ABFab.configure do
      define_test :integer do
        values 5
      end
    end

    ABFab.tests[:integer].values.should == [1, 2, 3, 4, 5]
  end

  it "a test with a hash given for values should use stringified sorted weighted keys as values" do
    # sorted for rubies without ordered hashes, and stringified to be sure they'll sort.

    ABFab.configure do
      define_test :hash do
        values :dog => 1, :cat => 4
      end
    end

    ABFab.tests[:hash].values.should == %w(cat cat cat cat dog)
  end

  it "a test with a range given for values should use the values inside it" do
    ABFab.configure do
      define_test :range do
        values 5..8
      end
    end

    ABFab.tests[:range].values.should == [5, 6, 7, 8]
  end

  it "should accept a Redis instance" do
    redis_client = Redis.new
    ABFab.configure do
      redis redis_client
    end

    ABFab.redis.should == redis_client
  end
end

require 'spec_helper'

describe "The fabulous! helper" do
  include ABFab::Helpers

  Words = %w(eleven cranky ferrets gave my mother rabies)

  before do
    ABFab.configure do
      define_test :fabulous_example do
        values Words
      end
    end
  end

  def abfab_id
    @id ||= random_id
  end

  def random_id
    rand(2**16)
  end

  it "should not do anything if the user hasn't participated in the test" do
    word = ab_choose(:fabulous_example)

    fabulous! :fabulous_example

    $redis.get("ABFab:fabulous_example:#{word}:participants").should == nil
    $redis.get("ABFab:fabulous_example:#{word}:conversions").should  == nil
  end

  it "should mark a user as a conversion if they've participated in the test" do
    id   = abfab_id
    word = ab_test(:fabulous_example)

    fabulous! :fabulous_example

    $redis.smembers("ABFab:fabulous_example:#{word}:participants").should == [id.to_s]
    $redis.smembers("ABFab:fabulous_example:#{word}:conversions").should  == [id.to_s]
  end

  it "should not convert the same user twice" do
    id   = abfab_id
    word = ab_test(:fabulous_example)

    fabulous! :fabulous_example
    fabulous! :fabulous_example

    $redis.smembers("ABFab:fabulous_example:#{word}:participants").should == [id.to_s]
    $redis.smembers("ABFab:fabulous_example:#{word}:conversions").should  == [id.to_s]
  end

  it "should be able to convert multiple tests" do
    ABFab.configure do
      define_test :other_fabulous_example do
        values Words
      end
    end

    word  = ab_test(:fabulous_example)
    other = ab_test(:other_fabulous_example)
    id    = abfab_id

    fabulous! :fabulous_example, :other_fabulous_example

    $redis.smembers("ABFab:fabulous_example:#{word}:participants").should == [id.to_s]
    $redis.smembers("ABFab:fabulous_example:#{word}:conversions").should  == [id.to_s]

    $redis.smembers("ABFab:other_fabulous_example:#{other}:participants").should == [id.to_s]
    $redis.smembers("ABFab:other_fabulous_example:#{other}:conversions").should  == [id.to_s]
  end
end

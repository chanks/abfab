require 'spec_helper'

describe "The fabulous! helper" do
  include ABFab::Helpers

  words = %w(eleven cranky ferrets gave my mother rabies)

  before do
    ABFab.configure do
      define_test :fabulous_example do
        values words
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
    key  = ABFab.tests[:fabulous_example].key_for(word)

    fabulous! :fabulous_example

    $redis.get("#{key}:participants").should == nil
    $redis.get("#{key}:conversions").should  == nil
  end

  it "should mark a user as a conversion if they've participated in the test" do
    id   = abfab_id
    word = ab_test(:fabulous_example)
    key  = ABFab.tests[:fabulous_example].key_for(word)

    fabulous! :fabulous_example

    $redis.smembers("#{key}:participants").should == [id.to_s]
    $redis.smembers("#{key}:conversions").should  == [id.to_s]
  end

  it "should not convert the same user twice" do
    id   = abfab_id
    word = ab_test(:fabulous_example)
    key  = ABFab.tests[:fabulous_example].key_for(word)

    fabulous! :fabulous_example
    fabulous! :fabulous_example

    $redis.smembers("#{key}:participants").should == [id.to_s]
    $redis.smembers("#{key}:conversions").should  == [id.to_s]
  end

  it "should be able to convert multiple tests" do
    ABFab.configure do
      define_test :other_fabulous_example do
        values words
      end
    end

    id    = abfab_id
    word  = ab_test(:fabulous_example)
    other = ab_test(:other_fabulous_example)
    key1  = ABFab.tests[:fabulous_example].key_for(word)
    key2  = ABFab.tests[:other_fabulous_example].key_for(other)

    fabulous! :fabulous_example, :other_fabulous_example

    $redis.smembers("#{key1}:participants").should == [id.to_s]
    $redis.smembers("#{key1}:conversions").should  == [id.to_s]

    $redis.smembers("#{key2}:participants").should == [id.to_s]
    $redis.smembers("#{key2}:conversions").should  == [id.to_s]
  end
end

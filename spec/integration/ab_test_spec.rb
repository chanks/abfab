require 'spec_helper'

describe "The ab_test helper" do
  context "should behave like an ab_choose helper" do
    before { @helper_name = :ab_test }
    it_should_behave_like "an ab_choose helper"
  end
end

describe "The ab_test helper" do
  include ABFab::Helpers

  Words = %w(eleven cranky ferrets gave my mother rabies)

  before do
    ABFab.configure do
      define_test :ab_test_example do
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

  it "should register the user as being given that particular value" do
    id   = abfab_id
    word = ab_test(:ab_test_example)
    key  = ABFab.tests[:ab_test_example].key_for(word, :participants)

    $redis.smembers(key).should == [id.to_s]
  end

  it "should not register the same user twice" do
    id   = abfab_id
    word = ab_test(:ab_test_example) && ab_test(:ab_test_example)
    key  = ABFab.tests[:ab_test_example].key_for(word, :participants)

    $redis.smembers(key).should == [id.to_s]
  end
end

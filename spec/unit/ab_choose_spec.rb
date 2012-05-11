require 'spec_helper'

describe "The ab_choose helper" do
  include ABFab::Helpers

  Words = %w(eleven cranky ferrets gave my mother rabies)

  before do
    ABFab.configure do
      define_test :ab_choose_example do
        possibilities Words
      end
    end
  end

  def abfab_id
    @id ||= random_id
  end

  def random_id
    rand(2**16)
  end

  it "should return the same results every time for a given user" do
    results = (1..100).map { ab_choose :ab_choose_example }
    results.uniq.length.should == 1
    Words.should include results.first
  end

  it "should return different values for different users unpredictably" do
    results = []

    100.times do
      results << ab_choose(:ab_choose_example)
      @id = nil # New abfab_id each time.
    end

    results.uniq.sort.should == Words.sort
    # TODO: Some kind of spec to ensure that the possibilities see a random distribution.
  end
end

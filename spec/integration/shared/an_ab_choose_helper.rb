shared_examples_for "an ab_choose helper" do
  # these specs assume the helper method name is in @helper_name.

  include ABFab::Helpers

  Words = %w(eleven cranky ferrets gave my mother rabies)

  before do
    ABFab.configure do
      define_test :ab_choose_example do
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

  it "should return the same results every time for a given user" do
    results = (1..100).map { send(@helper_name, :ab_choose_example) }
    results.uniq.length.should == 1
    Words.should include results.first
  end

  it "should return different values for different users unpredictably" do
    results = []

    100.times do
      results << send(@helper_name, :ab_choose_example)
      @id = nil # New abfab_id each time.
    end

    results.uniq.sort.should == Words.sort
    # TODO: Some kind of spec to ensure that the values see a random distribution.
  end

  it "should yield the value it chooses in a block, as well as returning it" do
    yielded = nil

    returned = send(@helper_name, :ab_choose_example) do |result|
      yielded = result
      "Return value of block doesn't matter."
    end

    returned.should == yielded
  end

  it "for different tests should return different values for the same user unpredictably" do
    # This will fail one in a thousand times. Find a better way to do this?

    ABFab.configure do
      define_test :hundred_one do
        values 1000
      end

      define_test :hundred_two do
        values 1000
      end
    end

    send(@helper_name, :hundred_one).should_not == send(@helper_name, :hundred_two)
  end
end

require 'spec_helper'

describe "The ab_test helper" do
  context "should behave like an ab_choose helper" do
    before { @helper_name = :ab_test }
    it_should_behave_like "an ab_choose helper"
  end
end

require 'spec_helper'

describe "The ab_choose helper" do
  context "should behave like an ab_choose helper" do
    before { @helper_name = :ab_choose }
    it_should_behave_like "an ab_choose helper"
  end
end

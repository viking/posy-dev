require File.dirname(__FILE__) + '/../spec_helper'

describe Dog do
  before(:each) do
    @dog = Dog.new
  end

  it "should be valid" do
    @dog.should be_valid
  end
end

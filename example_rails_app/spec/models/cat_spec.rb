require File.dirname(__FILE__) + '/../spec_helper'

describe Cat do
  before(:each) do
    @cat = Cat.new
  end

  it "should be valid" do
    @cat.should be_valid
  end
end

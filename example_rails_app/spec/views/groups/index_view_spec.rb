require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /groups/index" do
  before do
    @group = mock_model(Group, {
      :name => "foo", :description => "the foo group", :permanent => false
    })
    assigns[:groups] = Array.new(3) { |i| @group }
  end
 
  it "should not raise an error" do
    lambda { render 'groups/index' }.should_not raise_error
  end
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /groups/new" do
  before do
    @group = mock_model(Group, {
      :name => nil, :description => nil, :permanent => nil
    })
    assigns[:group] = @group
  end

  it "should not raise an error" do
    lambda { render 'groups/new' }.should_not raise_error
  end

  it "should have div#errorExplanation when @group has errors" do
    errors = stub("errors", :count => 1, :full_messages => ["Name can't be blank"])
    @group.stub!(:errors).and_return(errors)
    render 'groups/new'
    response.should have_tag("div#errorExplanation")
  end
end

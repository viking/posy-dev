require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /sessions/new" do
  it "should not raise an error" do
    lambda { render 'sessions/new' }.should_not raise_error
  end

  it "should have a form with an action of /sessions" do
    render 'sessions/new'
    response.should have_tag("form[action=/sessions]")
  end
end

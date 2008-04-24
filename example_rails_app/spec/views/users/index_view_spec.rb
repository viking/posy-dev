require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /users/index" do
  before do
    @user = mock_model(User, :login => "foo", :email => "foo@bar.com")
    assigns[:users] = Array.new(3, @user)
  end
 
  it "should not raise an error" do
    lambda { render 'users/index' }.should_not raise_error
  end
end

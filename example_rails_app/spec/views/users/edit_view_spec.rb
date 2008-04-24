require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /users/edit" do
  before do
    @user = mock_model(User, {
      :login => "foo", :email => "foo@bar.com", 
      :password => nil, :password_confirmation => nil
    })
    assigns[:user] = @user
  end

  it "should not raise an error" do
    lambda { render 'users/edit' }.should_not raise_error
  end

  it "should have div#errorExplanation when @user has errors" do
    errors = stub("errors", :count => 1, :full_messages => ["Login can't be blank"])
    @user.stub!(:errors).and_return(errors)
    render 'users/edit'
    response.should have_tag("div#errorExplanation")
  end
end

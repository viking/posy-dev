require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /users/show" do
  before do
    @group = mock_model(Group, {
      :name => 'dudes', :description => 'a group for dudes', :permanent => false
    })
    @groups = Array.new(3, @group)
    @user = mock_model(User, {
      :login => "foo", :email => "foo@bar.com", :created_at => Time.now, 
      :updated_at => Time.now, :creator => @user, :updater => @user, :groups => @groups
    })
    assigns[:user] = @user
  end
  
  it "should not raise an error" do
    lambda { render 'users/show' }.should_not raise_error
  end
end

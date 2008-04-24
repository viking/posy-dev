require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /memberships/index" do
  before do
    @user  = mock_model(User, :login => "dude")
    @group = mock_model(Group, :name => "dudes")
    @membership = mock_model(Membership, :user => @user, :group => @group)
    @memberships = Array.new(3, @membership)
    assigns[:memberships] = @memberships
  end
  
  it "should not raise an error" do
    lambda { render 'memberships/index' }.should_not raise_error
  end
end

describe "rendering /memberships/index when @user is set" do
  before do
    @user  = mock_model(User, :login => "dude")
    @group = mock_model(Group, :name => "dudes")
    @membership = mock_model(Membership, :user => @user, :group => @group)
    @memberships = Array.new(3, @membership)
    assigns[:memberships] = @memberships
    assigns[:user] = @user
  end
  
  it "should not raise an error" do
    lambda { render 'memberships/index' }.should_not raise_error
  end

  it "should have a back link to user_url(@user)" do
    render 'memberships/index'
    url = "/users/#{@user.id}" 
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

describe "rendering /memberships/index when @group is set" do
  before do
    @user  = mock_model(User, :login => "dude")
    @group = mock_model(Group, :name => "dudes")
    @membership = mock_model(Membership, :user => @user, :group => @group)
    @memberships = Array.new(3, @membership)
    assigns[:memberships] = @memberships
    assigns[:group] = @group
  end
  
  it "should not raise an error" do
    lambda { render 'memberships/index' }.should_not raise_error
  end

  it "should have a back link to group_url(@group)" do
    render 'memberships/index'
    url = "/groups/#{@group.id}" 
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

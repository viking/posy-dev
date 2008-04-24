require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /memberships/new" do
  before do
    @user  = mock_model(User, :login => "dude")
    @group = mock_model(Group, :name => "dudes")
    @membership = mock_model(Membership, :user => nil, :group => nil)
    @users  = Array.new(3, @user)
    @groups = Array.new(3, @group)
    assigns[:users]  = @users
    assigns[:groups] = @groups
  end
  
  it "should not raise an error" do
    lambda { render 'memberships/new' }.should_not raise_error
  end

  it "should have a groups select box" do
    render 'memberships/new'
    response.should have_tag("select#membership_group_id")
  end

  it "should have a users select box" do
    render 'memberships/new'
    response.should have_tag("select#membership_user_id")
  end
end

describe "rendering /memberships/new when @user is set" do
  before do
    @user  = mock_model(User, :login => "dude")
    @group = mock_model(Group, :name => "dudes")
    @membership = mock_model(Membership, :user => nil, :group => nil)
    @groups = Array.new(3, @group)
    assigns[:user]   = @user
    assigns[:groups] = @groups
  end

  it "should not raise an error" do
    lambda { render 'memberships/new' }.should_not raise_error
  end

  it "should not have a users select box" do
    render 'memberships/new'
    response.should_not have_tag("select#membership_user_id")
  end
end

describe "rendering /memberships/new when @group is set" do
  before do
    @user  = mock_model(User, :login => "dude")
    @group = mock_model(Group, :name => "dudes")
    @membership = mock_model(Membership, :user => nil, :group => nil)
    @users = Array.new(3, @user)
    assigns[:users] = @users
    assigns[:group] = @group
  end

  it "should not raise an error" do
    lambda { render 'memberships/new' }.should_not raise_error
  end

  it "should not have a groups select box" do
    render 'memberships/new'
    response.should_not have_tag("select#membership_group_id")
  end
end

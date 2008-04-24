require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /memberships/show" do
  before do
    @user  = mock_model(User, :login => 'dude')
    @group = mock_model(Group, :name => 'dudes')
    @membership = mock_model(Membership, {
      :user => @user, :group => @group, :created_at => Time.now, :updated_at => Time.now,
      :creator => @user, :updater => @user
    })
    assigns[:membership] = @membership
  end 

  it "should not raise an error" do
    lambda { render 'memberships/show' }.should_not raise_error
  end

  it "should have a link to group_url(@membership.group)" do
    render 'memberships/show'
    url = group_url(@membership.group)
    response.should have_tag("a[href=#{url}]", @group.name)
  end

  it "should have a link to user_url(@membership.user)" do
    render 'memberships/show'
    url = user_url(@membership.user)
    response.should have_tag("a[href=#{url}]", @user.login)
  end

  it "should have a back link to memberships_path" do
    render 'memberships/show'
    url = "/memberships" 
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

describe "rendering /memberships/show when @user is set" do
  before do
    @user  = mock_model(User, :login => 'dude')
    @group = mock_model(Group, :name => 'dudes')
    @membership = mock_model(Membership, {
      :user => @user, :group => @group, :created_at => Time.now, :updated_at => Time.now,
      :creator => @user, :updater => @user
    })
    assigns[:membership] = @membership
    assigns[:user] = @user
  end 

  it "should not raise an error" do
    lambda { render 'memberships/show' }.should_not raise_error
  end

  it "should have a back link to user_memberships_path(@user)" do
    render 'memberships/show'
    url = "/users/#{@user.id}/memberships" 
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

describe "rendering /memberships/show when @group is set" do
  before do
    @user  = mock_model(User, :login => 'dude')
    @group = mock_model(Group, :name => 'dudes')
    @membership = mock_model(Membership, {
      :user => @user, :group => @group, :created_at => Time.now, :updated_at => Time.now,
      :creator => @user, :updater => @user
    })
    assigns[:membership] = @membership
    assigns[:group] = @group
  end 

  it "should not raise an error" do
    lambda { render 'memberships/show' }.should_not raise_error
  end

  it "should have a back link to group_memberships_path(@group)" do
    render 'memberships/show'
    url = "/groups/#{@group.id}/memberships" 
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe MembershipsHelper do
  include MembershipsHelper

  describe "#link_to_index" do

    it "should return user link when @user exists" do
      @user = mock_model(User)
      link_to_index("foo").should == 
        link_to("foo", :controller => 'memberships', :action => 'index', :user_id => @user.id, :only_path => true)
    end

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_index("foo").should == 
        link_to("foo", :controller => 'memberships', :action => 'index', :group_id => @group.id, :only_path => true)
    end

    it "should return normal link when neither @user or @group exists" do
      link_to_index("foo").should == 
        link_to("foo", :controller => 'memberships', :action => 'index', :only_path => true)
    end
  end

  describe "#link_to_new" do

    it "should return user link when @user exists" do
      @user = mock_model(User)
      link_to_new("foo").should == 
        link_to("foo", :controller => 'memberships', :action => 'new', :user_id => @user.id, :only_path => true)
    end

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_new("foo").should == 
        link_to("foo", :controller => 'memberships', :action => 'new', :group_id => @group.id, :only_path => true)
    end

    it "should return normal link when neither @user or @group exists" do
      link_to_new("foo").should == 
        link_to("foo", :controller => 'memberships', :action => 'new', :only_path => true)
    end
  end

  describe "#link_to_show" do

    before(:each) do
      @membership = mock_model(Membership)
    end

    it "should return user link when @user exists" do
      @user = mock_model(User)
      link_to_show("foo", @membership).should == 
        link_to("foo", :controller => 'memberships', :action => 'show', :user_id => @user.id, :id => @membership.id, :only_path => true)
    end

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_show("foo", @membership).should == 
        link_to("foo", :controller => 'memberships', :action => 'show', :group_id => @group.id, :id => @membership.id, :only_path => true)
    end

    it "should return normal link when neither @user or @group exists" do
      link_to_show("foo", @membership).should == 
        link_to("foo", :controller => 'memberships', :action => 'show', :id => @membership.id, :only_path => true)
    end
  end

  describe "#link_to_destroy" do

    before(:each) do
      @membership = mock_model(Membership)
    end

    it "should return user link when @user exists" do
      @user = mock_model(User)
      link_to_destroy("foo", @membership).should == 
        link_to("foo", { :controller => 'memberships', :action => 'destroy', :user_id => @user.id, :id => @membership.id, :only_path => true }, :method => :delete)
    end

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_destroy("foo", @membership).should == 
        link_to("foo", { :controller => 'memberships', :action => 'destroy', :group_id => @group.id, :id => @membership.id, :only_path => true }, :method => :delete)
    end

    it "should return normal link when neither @user or @group exists" do
      link_to_destroy("foo", @membership).should == 
        link_to("foo", { :controller => 'memberships', :action => 'destroy', :id => @membership.id, :only_path => true }, :method => :delete)
    end
  end

  describe "#url_for_create" do

    it "should return user url when @user exists" do
      @user = mock_model(User)
      url_for_create.should == url_for(:controller => 'memberships', :action => 'create', :user_id => @user.id, :only_path => true)
    end

    it "should return group url when @group exists" do
      @group = mock_model(Group)
      url_for_create.should == url_for(:controller => 'memberships', :action => 'create', :group_id => @group.id, :only_path => true)
    end

    it "should return normal url when neither @user or @group exists" do
      url_for_create.should == url_for(:controller => 'memberships', :action => 'create', :only_path => true)
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe PermissionsHelper do
  include PermissionsHelper
  
  describe "#link_to_index" do

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_index("foo").should == 
        link_to("foo", :controller => 'permissions', :action => 'index', :group_id => @group.id, :only_path => true)
    end

    it "should return normal link when @group doesn't exist" do
      link_to_index("foo").should == 
        link_to("foo", :controller => 'permissions', :action => 'index', :only_path => true)
    end
  end

  describe "#link_to_new" do

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_new("foo").should == 
        link_to("foo", :controller => 'permissions', :action => 'new', :group_id => @group.id, :only_path => true)
    end

    it "should return normal link when @group doesn't exist" do
      link_to_new("foo").should == 
        link_to("foo", :controller => 'permissions', :action => 'new', :only_path => true)
    end
  end

  describe "#link_to_show" do

    before(:each) do
      @permission = mock_model(Permission)
    end

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_show("foo", @permission).should == 
        link_to("foo", :controller => 'permissions', :action => 'show', :group_id => @group.id, :id => @permission.id, :only_path => true)
    end

    it "should return normal link when @group doesn't exist" do
      link_to_show("foo", @permission).should == 
        link_to("foo", :controller => 'permissions', :action => 'show', :id => @permission.id, :only_path => true)
    end
  end

  describe "#link_to_destroy" do

    before(:each) do
      @permission = mock_model(Permission)
    end

    it "should return group link when @group exists" do
      @group = mock_model(Group)
      link_to_destroy("foo", @permission).should == 
        link_to("foo", { :controller => 'permissions', :action => 'destroy', :group_id => @group.id, :id => @permission.id, :only_path => true }, :method => :delete)
    end

    it "should return normal link when @group doesn't exist" do
      link_to_destroy("foo", @permission).should == 
        link_to("foo", { :controller => 'permissions', :action => 'destroy', :id => @permission.id, :only_path => true }, :method => :delete)
    end
  end

  describe "#url_for_create" do

    it "should return group url when @group exists" do
      @group = mock_model(Group)
      url_for_create.should == url_for(:controller => 'permissions', :action => 'create', :group_id => @group.id, :only_path => true)
    end

    it "should return normal url when @group doesn't exist" do
      url_for_create.should == url_for(:controller => 'permissions', :action => 'create', :only_path => true)
    end
  end

  describe "#url_for_update" do

    before(:each) do
      @permission = mock_model(Permission)
    end

    it "should return group url when @group exists" do
      @group = mock_model(Group)
      url_for_update(@permission).should == url_for(:controller => 'permissions', :action => 'update', :id => @permission.id, :group_id => @group.id, :only_path => true)
    end

    it "should return normal url when @group doesn't exist" do
      url_for_update(@permission).should == url_for(:controller => 'permissions', :action => 'update', :id => @permission.id, :only_path => true)
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe PermissionsController do

  describe "route generation" do

    it "should map { :controller => 'permissions', :action => 'index' } to /permissions" do
      route_for(:controller => "permissions", :action => "index").should == "/permissions"
    end
    
    it "should map { :controller => 'permissions', :action => 'new' } to /permissions/new" do
      route_for(:controller => "permissions", :action => "new").should == "/permissions/new"
    end
    
    it "should map { :controller => 'permissions', :action => 'show', :id => 1 } to /permissions/1" do
      route_for(:controller => "permissions", :action => "show", :id => 1).should == "/permissions/1"
    end
    
    it "should map { :controller => 'permissions', :action => 'edit', :id => 1 } to /permissions/1/edit" do
      route_for(:controller => "permissions", :action => "edit", :id => 1).should == "/permissions/1/edit"
    end
    
    it "should map { :controller => 'permissions', :action => 'update', :id => 1} to /permissions/1" do
      route_for(:controller => "permissions", :action => "update", :id => 1).should == "/permissions/1"
    end
    
    it "should map { :controller => 'permissions', :action => 'destroy', :id => 1} to /permissions/1" do
      route_for(:controller => "permissions", :action => "destroy", :id => 1).should == "/permissions/1"
    end
    
    describe "for groups" do
      it "should map { :controller => 'permissions', :action => 'index', :group_id => 1 } to /groups/1/permissions" do
        route_for(:controller => "permissions", :action => "index", :group_id => 1).should == "/groups/1/permissions"
      end
      
      it "should map { :controller => 'permissions', :action => 'new', :group_id => 1 } to /groups/1/permissions/new" do
        route_for(:controller => "permissions", :action => "new", :group_id => 1).should == "/groups/1/permissions/new"
      end
      
      it "should map { :controller => 'permissions', :action => 'show', :id => 1, :group_id => 1 } to /groups/1/permissions/1" do
        route_for(:controller => "permissions", :action => "show", :id => 1, :group_id => 1).should == "/groups/1/permissions/1"
      end
      
      it "should map { :controller => 'permissions', :action => 'destroy', :id => 1, :group_id => 1 } to /groups/1/permissions/1" do
        route_for(:controller => "permissions", :action => "destroy", :id => 1, :group_id => 1).should == "/groups/1/permissions/1"
      end
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'permissions', action => 'index' } from GET /permissions" do
      params_from(:get, "/permissions").should == {:controller => "permissions", :action => "index"}
    end
  
    it "should generate params { :controller => 'permissions', action => 'new' } from GET /permissions/new" do
      params_from(:get, "/permissions/new").should == {:controller => "permissions", :action => "new"}
    end
  
    it "should generate params { :controller => 'permissions', action => 'create' } from POST /permissions" do
      params_from(:post, "/permissions").should == {:controller => "permissions", :action => "create"}
    end
  
    it "should generate params { :controller => 'permissions', action => 'show', id => '1' } from GET /permissions/1" do
      params_from(:get, "/permissions/1").should == {:controller => "permissions", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'permissions', action => 'edit', id => '1' } from GET /permissions/1/edit" do
      params_from(:get, "/permissions/1/edit").should == {:controller => "permissions", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'permissions', action => 'update', id => '1' } from PUT /permissions/1" do
      params_from(:put, "/permissions/1").should == {:controller => "permissions", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'permissions', action => 'destroy', id => '1' } from DELETE /permissions/1" do
      params_from(:delete, "/permissions/1").should == {:controller => "permissions", :action => "destroy", :id => "1"}
    end

    describe "for groups" do
      it "should generate params { :controller => 'permissions', action => 'index', :group_id => 1 } from GET /groups/1/permissions" do
        params_from(:get, "/groups/1/permissions").should == {:controller => "permissions", :action => "index", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'permissions', action => 'new', :group_id => 1 } from GET /groups/1/permissions/new" do
        params_from(:get, "/groups/1/permissions/new").should == {:controller => "permissions", :action => "new", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'permissions', action => 'create', :group_id => 1 } from POST /groups/1/permissions" do
        params_from(:post, "/groups/1/permissions").should == {:controller => "permissions", :action => "create", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'permissions', action => 'show', id => '1', :group_id => 1 } from GET /groups/1/permissions/1" do
        params_from(:get, "/groups/1/permissions/1").should == {:controller => "permissions", :action => "show", :id => "1", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'permissions', action => 'edit', id => '1', :group_id => 1 } from GET /groups/1/permissions/1/edit" do
        params_from(:get, "/groups/1/permissions/1/edit").should == {:controller => "permissions", :action => "edit", :id => "1", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'permissions', action => 'update', id => '1', :group_id => 1 } from PUT /groups/1/permissions/1" do
        params_from(:put, "/groups/1/permissions/1").should == {:controller => "permissions", :action => "update", :id => "1", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'permissions', action => 'destroy', id => '1', :group_id => 1 } from DELETE /groups/1/permissions/1" do
        params_from(:delete, "/groups/1/permissions/1").should == {:controller => "permissions", :action => "destroy", :id => "1", :group_id => "1"}
      end
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe MembershipsController do
  
  describe "route generation" do

    it "should map { :controller => 'memberships', :action => 'index' } to /memberships" do
      route_for(:controller => "memberships", :action => "index").should == "/memberships"
    end
    
    it "should map { :controller => 'memberships', :action => 'new' } to /memberships/new" do
      route_for(:controller => "memberships", :action => "new").should == "/memberships/new"
    end
    
    it "should map { :controller => 'memberships', :action => 'show', :id => 1 } to /memberships/1" do
      route_for(:controller => "memberships", :action => "show", :id => 1).should == "/memberships/1"
    end
    
    it "should map { :controller => 'memberships', :action => 'destroy', :id => 1} to /memberships/1" do
      route_for(:controller => "memberships", :action => "destroy", :id => 1).should == "/memberships/1"
    end

    describe "for groups" do
      it "should map { :controller => 'memberships', :action => 'index', :group_id => 1 } to /groups/1/memberships" do
        route_for(:controller => "memberships", :action => "index", :group_id => 1).should == "/groups/1/memberships"
      end
      
      it "should map { :controller => 'memberships', :action => 'new', :group_id => 1 } to /groups/1/memberships/new" do
        route_for(:controller => "memberships", :action => "new", :group_id => 1).should == "/groups/1/memberships/new"
      end
      
      it "should map { :controller => 'memberships', :action => 'show', :id => 1, :group_id => 1 } to /groups/1/memberships/1" do
        route_for(:controller => "memberships", :action => "show", :id => 1, :group_id => 1).should == "/groups/1/memberships/1"
      end
      
      it "should map { :controller => 'memberships', :action => 'destroy', :id => 1, :group_id => 1 } to /groups/1/memberships/1" do
        route_for(:controller => "memberships", :action => "destroy", :id => 1, :group_id => 1).should == "/groups/1/memberships/1"
      end
    end

    describe "for users" do
      it "should map { :controller => 'memberships', :action => 'index', :user_id => 1 } to /users/1/memberships" do
        route_for(:controller => "memberships", :action => "index", :user_id => 1).should == "/users/1/memberships"
      end
      
      it "should map { :controller => 'memberships', :action => 'new', :user_id => 1 } to /users/1/memberships/new" do
        route_for(:controller => "memberships", :action => "new", :user_id => 1).should == "/users/1/memberships/new"
      end
      
      it "should map { :controller => 'memberships', :action => 'show', :id => 1, :user_id => 1 } to /users/1/memberships/1" do
        route_for(:controller => "memberships", :action => "show", :id => 1, :user_id => 1).should == "/users/1/memberships/1"
      end
      
      it "should map { :controller => 'memberships', :action => 'destroy', :id => 1, :user_id => 1 } to /users/1/memberships/1" do
        route_for(:controller => "memberships", :action => "destroy", :id => 1, :user_id => 1).should == "/users/1/memberships/1"
      end
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'memberships', action => 'index' } from GET /memberships" do
      params_from(:get, "/memberships").should == {:controller => "memberships", :action => "index"}
    end
  
    it "should generate params { :controller => 'memberships', action => 'new' } from GET /memberships/new" do
      params_from(:get, "/memberships/new").should == {:controller => "memberships", :action => "new"}
    end
  
    it "should generate params { :controller => 'memberships', action => 'create' } from POST /memberships" do
      params_from(:post, "/memberships").should == {:controller => "memberships", :action => "create"}
    end
  
    it "should generate params { :controller => 'memberships', action => 'show', id => '1' } from GET /memberships/1" do
      params_from(:get, "/memberships/1").should == {:controller => "memberships", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'memberships', action => 'edit', id => '1' } from GET /memberships/1/edit" do
      params_from(:get, "/memberships/1/edit").should == {:controller => "memberships", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'memberships', action => 'update', id => '1' } from PUT /memberships/1" do
      params_from(:put, "/memberships/1").should == {:controller => "memberships", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'memberships', action => 'destroy', id => '1' } from DELETE /memberships/1" do
      params_from(:delete, "/memberships/1").should == {:controller => "memberships", :action => "destroy", :id => "1"}
    end

    describe "for groups" do
      it "should generate params { :controller => 'memberships', action => 'index', :group_id => 1 } from GET /groups/1/memberships" do
        params_from(:get, "/groups/1/memberships").should == {:controller => "memberships", :action => "index", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'new', :group_id => 1 } from GET /groups/1/memberships/new" do
        params_from(:get, "/groups/1/memberships/new").should == {:controller => "memberships", :action => "new", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'create', :group_id => 1 } from POST /groups/1/memberships" do
        params_from(:post, "/groups/1/memberships").should == {:controller => "memberships", :action => "create", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'show', id => '1', :group_id => 1 } from GET /groups/1/memberships/1" do
        params_from(:get, "/groups/1/memberships/1").should == {:controller => "memberships", :action => "show", :id => "1", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'edit', id => '1', :group_id => 1 } from GET /groups/1/memberships/1/edit" do
        params_from(:get, "/groups/1/memberships/1/edit").should == {:controller => "memberships", :action => "edit", :id => "1", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'update', id => '1', :group_id => 1 } from PUT /groups/1/memberships/1" do
        params_from(:put, "/groups/1/memberships/1").should == {:controller => "memberships", :action => "update", :id => "1", :group_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'destroy', id => '1', :group_id => 1 } from DELETE /groups/1/memberships/1" do
        params_from(:delete, "/groups/1/memberships/1").should == {:controller => "memberships", :action => "destroy", :id => "1", :group_id => "1"}
      end
    end
  
    describe "for users" do
      it "should generate params { :controller => 'memberships', action => 'index', :user_id => 1 } from GET /users/1/memberships" do
        params_from(:get, "/users/1/memberships").should == {:controller => "memberships", :action => "index", :user_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'new', :user_id => 1 } from GET /users/1/memberships/new" do
        params_from(:get, "/users/1/memberships/new").should == {:controller => "memberships", :action => "new", :user_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'create', :user_id => 1 } from POST /users/1/memberships" do
        params_from(:post, "/users/1/memberships").should == {:controller => "memberships", :action => "create", :user_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'show', id => '1', :user_id => 1 } from GET /users/1/memberships/1" do
        params_from(:get, "/users/1/memberships/1").should == {:controller => "memberships", :action => "show", :id => "1", :user_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'edit', id => '1', :user_id => 1 } from GET /users/1/memberships/1/edit" do
        params_from(:get, "/users/1/memberships/1/edit").should == {:controller => "memberships", :action => "edit", :id => "1", :user_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'update', id => '1', :user_id => 1 } from PUT /users/1/memberships/1" do
        params_from(:put, "/users/1/memberships/1").should == {:controller => "memberships", :action => "update", :id => "1", :user_id => "1"}
      end
    
      it "should generate params { :controller => 'memberships', action => 'destroy', id => '1', :user_id => 1 } from DELETE /users/1/memberships/1" do
        params_from(:delete, "/users/1/memberships/1").should == {:controller => "memberships", :action => "destroy", :id => "1", :user_id => "1"}
      end
    end
  end
end

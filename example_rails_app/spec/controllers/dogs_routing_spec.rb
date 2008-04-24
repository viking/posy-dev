require File.dirname(__FILE__) + '/../spec_helper'

describe DogsController do
  describe "route generation" do

    it "should map { :controller => 'dogs', :action => 'index' } to /dogs" do
      route_for(:controller => "dogs", :action => "index").should == "/dogs"
    end
  
    it "should map { :controller => 'dogs', :action => 'new' } to /dogs/new" do
      route_for(:controller => "dogs", :action => "new").should == "/dogs/new"
    end
  
    it "should map { :controller => 'dogs', :action => 'show', :id => 1 } to /dogs/1" do
      route_for(:controller => "dogs", :action => "show", :id => 1).should == "/dogs/1"
    end
  
    it "should map { :controller => 'dogs', :action => 'edit', :id => 1 } to /dogs/1/edit" do
      route_for(:controller => "dogs", :action => "edit", :id => 1).should == "/dogs/1/edit"
    end
  
    it "should map { :controller => 'dogs', :action => 'update', :id => 1} to /dogs/1" do
      route_for(:controller => "dogs", :action => "update", :id => 1).should == "/dogs/1"
    end
  
    it "should map { :controller => 'dogs', :action => 'destroy', :id => 1} to /dogs/1" do
      route_for(:controller => "dogs", :action => "destroy", :id => 1).should == "/dogs/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'dogs', action => 'index' } from GET /dogs" do
      params_from(:get, "/dogs").should == {:controller => "dogs", :action => "index"}
    end
  
    it "should generate params { :controller => 'dogs', action => 'new' } from GET /dogs/new" do
      params_from(:get, "/dogs/new").should == {:controller => "dogs", :action => "new"}
    end
  
    it "should generate params { :controller => 'dogs', action => 'create' } from POST /dogs" do
      params_from(:post, "/dogs").should == {:controller => "dogs", :action => "create"}
    end
  
    it "should generate params { :controller => 'dogs', action => 'show', id => '1' } from GET /dogs/1" do
      params_from(:get, "/dogs/1").should == {:controller => "dogs", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'dogs', action => 'edit', id => '1' } from GET /dogs/1/edit" do
      params_from(:get, "/dogs/1/edit").should == {:controller => "dogs", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'dogs', action => 'update', id => '1' } from PUT /dogs/1" do
      params_from(:put, "/dogs/1").should == {:controller => "dogs", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'dogs', action => 'destroy', id => '1' } from DELETE /dogs/1" do
      params_from(:delete, "/dogs/1").should == {:controller => "dogs", :action => "destroy", :id => "1"}
    end
  end
end

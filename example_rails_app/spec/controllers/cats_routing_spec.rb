require File.dirname(__FILE__) + '/../spec_helper'

describe CatsController do
  describe "route generation" do

    it "should map { :controller => 'cats', :action => 'index' } to /cats" do
      route_for(:controller => "cats", :action => "index").should == "/cats"
    end
  
    it "should map { :controller => 'cats', :action => 'new' } to /cats/new" do
      route_for(:controller => "cats", :action => "new").should == "/cats/new"
    end
  
    it "should map { :controller => 'cats', :action => 'show', :id => 1 } to /cats/1" do
      route_for(:controller => "cats", :action => "show", :id => 1).should == "/cats/1"
    end
  
    it "should map { :controller => 'cats', :action => 'edit', :id => 1 } to /cats/1/edit" do
      route_for(:controller => "cats", :action => "edit", :id => 1).should == "/cats/1/edit"
    end
  
    it "should map { :controller => 'cats', :action => 'update', :id => 1} to /cats/1" do
      route_for(:controller => "cats", :action => "update", :id => 1).should == "/cats/1"
    end
  
    it "should map { :controller => 'cats', :action => 'destroy', :id => 1} to /cats/1" do
      route_for(:controller => "cats", :action => "destroy", :id => 1).should == "/cats/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'cats', action => 'index' } from GET /cats" do
      params_from(:get, "/cats").should == {:controller => "cats", :action => "index"}
    end
  
    it "should generate params { :controller => 'cats', action => 'new' } from GET /cats/new" do
      params_from(:get, "/cats/new").should == {:controller => "cats", :action => "new"}
    end
  
    it "should generate params { :controller => 'cats', action => 'create' } from POST /cats" do
      params_from(:post, "/cats").should == {:controller => "cats", :action => "create"}
    end
  
    it "should generate params { :controller => 'cats', action => 'show', id => '1' } from GET /cats/1" do
      params_from(:get, "/cats/1").should == {:controller => "cats", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'cats', action => 'edit', id => '1' } from GET /cats/1;edit" do
      params_from(:get, "/cats/1/edit").should == {:controller => "cats", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'cats', action => 'update', id => '1' } from PUT /cats/1" do
      params_from(:put, "/cats/1").should == {:controller => "cats", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'cats', action => 'destroy', id => '1' } from DELETE /cats/1" do
      params_from(:delete, "/cats/1").should == {:controller => "cats", :action => "destroy", :id => "1"}
    end
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController, "#route_for" do

  it "should map { :controller => 'sessions', :action => 'new' } to /sessions/new" do
    route_for(:controller => "sessions", :action => "new").should == "/sessions/new"
  end
  
  it "should map { :controller => 'sessions', :action => 'destroy', :id => 1} to /sessions/1" do
    route_for(:controller => "sessions", :action => "destroy", :id => 1).should == "/sessions/1"
  end
  
end

describe SessionsController do
  fixtures :users

  it "should successfully GET /sessions/new" do
    get :new
    response.should be_success
  end

  it "should redirect on valid POST to /sessions" do
    post :create, :login => 'admin', :password => 'test'
    response.should be_redirect
  end

  it "should set session[:user] on valid POST to /sessions" do
    post :create, :login => 'admin', :password => 'test'
    session[:user].should == users(:admin).id
  end

  it "should not redirect on invalid POST to /sessions" do
    post :create, :login => 'admin', :password => 'bad password'
    response.should be_success
  end

  it "should not set session[:user] on invalid POST to /sessions" do
    post :create, :login => 'admin', :password => 'bad password'
    session[:user].should be_nil 
  end

  it "should redirect on DELETE to /sessions" do
    delete :destroy
    response.should be_redirect
  end

  it "should unset session[:user] on DELETE to /sessions" do
    delete :destroy
    session[:user].should be_nil
  end
end

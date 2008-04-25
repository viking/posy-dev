require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do

  describe "when no one is logged in" do
    it "should redirect to /sessions/new on GET to index" do
      get :index
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end

    it "should redirect to /sessions/new on GET to new" do
      get :new
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end

    it "should redirect to /sessions/new on GET to show" do
      get :show, :id => "1"
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end

    it "should redirect to /sessions/new on GET to edit" do
      get :edit, :id => "1"
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end

    it "should redirect to /sessions/new on POST to create" do
      post :create
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end

    it "should redirect to /sessions/new on PUT to update" do
      put :update, :id => "1"
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end

    it "should redirect to /sessions/new on DELETE to destroy" do
      delete :destroy, :id => "1"
      response.should redirect_to(:controller => "sessions", :action => "new") 
    end
  end

  describe "when logged in as admin" do
    include AuthenticatedTestHelper
    fixtures :users, :groups, :memberships, :permissions

    before(:each) do
      login_as(:admin)
      @user = mock_model(User)
    end

    describe UsersController, "handling GET /users as admin" do

      before(:each) do
        User.stub!(:find).and_return([@user])

        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @users" do
        assigns[:users].should == [@user] 
      end
    end

    describe "handling GET /users/1" do

      before(:each) do
        User.stub!(:find).and_return(@user)

        get :show, :id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @user" do
        assigns[:user].should == @user
      end
    end

    describe "handling GET /users/new" do

      before(:each) do
        User.stub!(:new).and_return(@user)

        get :new
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @user" do
        assigns[:user].should == @user
      end
    end

    describe "handling GET /users/1/edit" do

      before(:each) do
        User.stub!(:find).and_return(@user)

        get :edit, :id => "1"
      end

      it "should GET /users/1/edit successfully" do
        response.should be_success
      end

      it "should have a @user after GET /users/1/edit" do
        assigns[:user].should == @user
      end
    end

    describe "handling POST /users" do

      before(:each) do
        User.stub!(:new).and_return(@user)
        @user.stub!(:save).and_return(true)
      end

      it "should redirect to /users/:id when valid" do
        post :create
        response.should redirect_to(user_url(@user))
      end

      it "should render 'new' when invalid" do
        @user.stub!(:save).and_return(false)
        post :create
        response.should render_template("new")
      end

      it "should set @user" do
        post :create
        assigns[:user].should == @user
      end
    end

    describe "handling PUT /users/1" do

      before(:each) do
        User.stub!(:find).and_return(@user)
        @user.stub!(:update_attributes).and_return(true)
      end

      it "should redirect to /users/:id when valid" do
        put :update, :id => '1'
        response.should redirect_to(user_url(@user))
      end

      it "should render 'edit' when invalid" do
        @user.stub!(:update_attributes).and_return(false)
        put :update, :id => '1'
        response.should render_template("edit")
      end

      it "should set @user" do
        put :update, :id => '1'
        assigns[:user].should == @user
      end
    end

    describe "handling DELETE /users/1" do

      before(:each) do
        User.stub!(:find).and_return(@user)
        @user.stub!(:destroy).and_return(@user)

        delete :destroy, :id => '1'
      end

      it "should redirect to /users" do
        response.should redirect_to(users_url)
      end

      it "should set @user" do
        assigns[:user].should == @user
      end
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe GroupsController do
  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

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

    before(:each) do
      login_as(:admin)
      @group = mock_model(Group)
    end

    describe "handling GET /groups" do

      before(:each) do
        Group.stub!(:find).and_return([@group])
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @groups" do
        assigns[:groups].should == [@group] 
      end
    end

    describe "handling GET /groups/1" do

      before(:each) do
        Group.stub!(:find).and_return(@group)

        get :show, :id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/new" do

      before(:each) do
        Group.stub!(:new).and_return(@group)

        get :new
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/1/edit" do

      before(:each) do
        Group.stub!(:find).and_return(@group)

        get :edit, :id => "1"
      end

      it "should GET /groups/1/edit successfully" do
        response.should be_success
      end

      it "should have a @group after GET /groups/1/edit" do
        assigns[:group].should == @group
      end
    end

    describe "handling POST /groups" do

      before(:each) do
        Group.stub!(:new).and_return(@group)
        @group.stub!(:save).and_return(true)
      end

      it "should redirect to /groups/:id when valid" do
        post :create
        response.should redirect_to(group_url(@group))
      end

      it "should render 'new' when invalid" do
        @group.stub!(:save).and_return(false)
        post :create
        response.should render_template("new")
      end

      it "should set @group" do
        post :create
        assigns[:group].should == @group
      end
    end

    describe "handling PUT /groups/1" do

      before(:each) do
        Group.stub!(:find).and_return(@group)
        @group.stub!(:update_attributes).and_return(true)
      end

      it "should redirect to /groups/:id when valid" do
        put :update, :id => '1'
        response.should redirect_to(group_url(@group))
      end

      it "should render 'edit' when invalid" do
        @group.stub!(:update_attributes).and_return(false)
        put :update, :id => '1'
        response.should render_template("edit")
      end

      it "should set @group" do
        put :update, :id => '1'
        assigns[:group].should == @group
      end
    end

    describe "handling DELETE /groups/1" do

      before(:each) do
        Group.stub!(:find).and_return(@group)
        @group.stub!(:destroy).and_return(@group)

        delete :destroy, :id => '1'
      end

      it "should redirect to /groups" do
        response.should redirect_to(groups_url)
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end
  end
end

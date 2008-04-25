require File.dirname(__FILE__) + '/../spec_helper'

describe MembershipsController do

  describe "when not logged in" do

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

    it "should redirect to /sessions/new on POST to create" do
      post :create
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
      @membership = mock_model(Membership)
      @group = mock_model(Group)
      @user  = mock_model(User)
    end
    
    describe "handling GET /memberships" do

      before(:each) do
        Membership.stub!(:find).and_return([@membership])
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @memberships" do
        assigns[:memberships].should == [@membership] 
      end
    end

    describe "handling GET /memberships/1" do

      before(:each) do
        Membership.stub!(:find).and_return(@membership)
        get :show, :id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end
    end

    describe "handling GET /memberships/new" do

      before(:each) do
        Membership.stub!(:new).and_return(@membership)
        User.stub!(:find).and_return([@user])
        Group.stub!(:find).and_return([@group])

        get :new
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @users" do
        assigns[:users].should == [@user]
      end

      it "should set @groups" do
        assigns[:groups].should == [@group]
      end
    end

    describe "handling POST /memberships" do

      before(:each) do
        Membership.stub!(:new).and_return(@membership)
        @membership.stub!(:save).and_return(true)
      end

      it "should redirect to /memberships/:id when valid" do
        post :create
        response.should redirect_to(membership_url(@membership))
      end

      it "should render 'new' when invalid" do
        @membership.stub!(:save).and_return(false)
        post :create
        response.should render_template("new")
      end

      it "should set @membership" do
        post :create
        assigns[:membership].should == @membership
      end
    end

    describe "handling DELETE /memberships/1" do

      before(:each) do
        Membership.stub!(:find).and_return(@membership)
        @membership.stub!(:destroy).and_return(@membership)

        delete :destroy, :id => '1'
      end

      it "should redirect to /memberships" do
        response.should redirect_to("/memberships")
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end
    end

    describe "handling GET /groups/1/memberships" do

      before(:each) do
        @group.stub!(:memberships).and_return([@membership])
        Group.stub!(:find).and_return(@group)

        get :index, :group_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @memberships" do
        assigns[:memberships].should == [@membership] 
      end

      it "should set @group" do
        assigns[:group].should == @group 
      end
    end

    describe "handling GET /groups/1/memberships/1" do

      before(:each) do
        Group.stub!(:find).and_return(@group)
        @membership_association = stub("association", :find => @membership)
        @group.stub!(:memberships).and_return(@membership_association)

        get :show, :id => "1", :group_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/1/memberships/new" do

      before(:each) do
        Group.stub!(:find).and_return(@group)
        User.stub!(:find).and_return([@user])
        @membership_association = stub("association", :build => @membership)
        @group.stub!(:memberships).and_return(@membership_association)

        get :new, :group_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @group" do
        assigns[:group].should == @group
      end

      it "should have @users" do
        assigns[:users].should == [@user] 
      end
    end

    describe "handling POST /groups/1/memberships" do

      before(:each) do
        @membership.stub!(:save).and_return(true)
        Group.stub!(:find).and_return(@group)
        User.stub!(:find).and_return([@user])
        @membership_association = stub("association", :build => @membership)
        @group.stub!(:memberships).and_return(@membership_association)
      end

      def do_post
        post :create, :group_id => "1"
      end

      it "should redirect to /groups/:id/memberships/:id when valid" do
        do_post
        response.should redirect_to(group_membership_url(@group, @membership))
      end

      it "should render 'new' when invalid" do
        @membership.stub!(:save).and_return(false)

        do_post
        response.should render_template("new")
      end

      it "should set @membership" do
        do_post
        assigns[:membership].should == @membership
      end

      it "should set @group" do
        do_post
        assigns[:group].should == @group
      end

      it "should set @users" do
        do_post
        assigns[:users].should == [@user] 
      end
    end

    describe "handling DELETE /groups/1/memberships/1" do

      before(:each) do
        @memberships = [@membership]
        @membership_association = stub("association", :find => @membership)
        Group.stub!(:find).and_return(@group)
        @group.stub!(:memberships).and_return(@membership_association)
        @membership.stub!(:destroy).and_return(@membership)

        delete :destroy, :id => '1', :group_id => "1"
      end

      it "should redirect to /groups/1/memberships" do
        response.should redirect_to(group_memberships_url(@group))
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /users/1/memberships" do

      before(:each) do
        @user.stub!(:memberships).and_return([@membership])
        User.stub!(:find).and_return(@user)

        get :index, :user_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @memberships" do
        assigns[:memberships].should == [@membership] 
      end

      it "should set @user" do
        assigns[:user].should == @user 
      end
    end

    describe "handling GET /users/1/memberships/1" do

      before(:each) do
        User.stub!(:find).and_return(@user)
        @membership_association = stub("association", :find => @membership)
        @user.stub!(:memberships).and_return(@membership_association)

        get :show, :id => "1", :user_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @user" do
        assigns[:user].should == @user
      end
    end

    describe "handling GET /users/1/memberships/new" do

      before(:each) do
        User.stub!(:find).and_return(@user)
        Group.stub!(:find).and_return([@group])
        @membership_association = stub("association", :build => @membership)
        @user.stub!(:memberships).and_return(@membership_association)

        get :new, :user_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @user" do
        assigns[:user].should == @user
      end

      it "should have @groups" do
        assigns[:groups].should == [@group] 
      end
    end

    describe "handling POST /users/1/memberships as admin" do

      before(:each) do
        @membership.stub!(:save).and_return(true)
        User.stub!(:find).and_return(@user)
        Group.stub!(:find).and_return([@group])
        @membership_association = stub("association", :build => @membership)
        @user.stub!(:memberships).and_return(@membership_association)
      end

      def do_post
        post :create, :user_id => "1"
      end

      it "should redirect to /users/:id/memberships/:id when valid" do
        do_post
        response.should redirect_to(user_membership_url(@user, @membership))
      end

      it "should render 'new' when invalid" do
        @membership.stub!(:save).and_return(false)

        do_post
        response.should render_template("new")
      end

      it "should set @membership" do
        do_post
        assigns[:membership].should == @membership
      end

      it "should set @user" do
        do_post
        assigns[:user].should == @user
      end

      it "should set @groups" do
        do_post
        assigns[:groups].should == [@group] 
      end
    end

    describe "handling DELETE /users/1/memberships/1" do

      before(:each) do
        @memberships = [@membership]
        @membership_association = stub("association", :find => @membership)
        User.stub!(:find).and_return(@user)
        @user.stub!(:memberships).and_return(@membership_association)
        @membership.stub!(:destroy).and_return(@membership)

        delete :destroy, :id => '1', :user_id => "1"
      end

      it "should redirect to /users/1/memberships" do
        response.should redirect_to(user_memberships_url(@user))
      end

      it "should set @membership" do
        assigns[:membership].should == @membership
      end

      it "should set @user" do
        assigns[:user].should == @user
      end
    end
  end
end

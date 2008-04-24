require File.dirname(__FILE__) + '/../spec_helper'

describe MembershipsController, "#route_for" do

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
  
end

describe MembershipsController, "when not logged in" do

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

describe MembershipsController, "handling GET /memberships as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    Membership.stub!(:find).and_return([])

    get :index
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @memberships" do
    assigns[:memberships].should == [] 
  end
end

describe MembershipsController, "handling GET /memberships/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
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

describe MembershipsController, "handling GET /memberships/new as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    Membership.stub!(:new).and_return(@membership)
    User.stub!(:find).and_return([])
    Group.stub!(:find).and_return([])

    get :new
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @membership" do
    assigns[:membership].should == @membership
  end

  it "should set @users" do
    assigns[:users].should == []
  end

  it "should set @groups" do
    assigns[:groups].should == []
  end
end

describe MembershipsController, "handling POST /memberships/ as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
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

describe MembershipsController, "handling DELETE /memberships/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
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

describe MembershipsController, "handling GET /groups/1/memberships as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @group = mock_model(Group)
    @group.stub!(:memberships).and_return([])
    Group.stub!(:find).and_return(@group)

    get :index, :group_id => "1"
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @memberships" do
    assigns[:memberships].should == [] 
  end

  it "should set @group" do
    assigns[:group].should == @group 
  end
end

describe MembershipsController, "handling GET /groups/1/memberships/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @group = mock_model(Group)
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

describe MembershipsController, "handling GET /groups/1/memberships/new as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @group = mock_model(Group)
    Group.stub!(:find).and_return(@group)
    User.stub!(:find).and_return([])
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
    assigns[:users].should == [] 
  end
end

describe MembershipsController, "handling POST /groups/1/permissions as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @membership.stub!(:save).and_return(true)
    @group = mock_model(Group)
    Group.stub!(:find).and_return(@group)
    User.stub!(:find).and_return([])
    @membership_association = stub("association", :build => @membership)
    @group.stub!(:memberships).and_return(@membership_association)
  end

  it "should redirect to /groups/:id/memberships/:id when valid" do
    post :create, :group_id => "1"
    response.should redirect_to(group_membership_url(@group, @membership))
  end

  it "should render 'new' when invalid" do
    @membership.stub!(:save).and_return(false)

    post :create, :group_id => "1"
    response.should render_template("new")
  end

  it "should set @membership" do
    post :create, :group_id => "1"
    assigns[:membership].should == @membership
  end

  it "should set @group" do
    get :new, :group_id => "1"
    assigns[:group].should == @group
  end

  it "should set @users" do
    get :new, :group_id => "1"
    assigns[:users].should == [] 
  end
end

describe MembershipsController, "handling DELETE /groups/1/memberships/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @memberships = [@membership]
    @group = mock_model(Group)
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

describe MembershipsController, "handling GET /users/1/memberships as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @user = mock_model(User)
    @user.stub!(:memberships).and_return([])
    User.stub!(:find).and_return(@user)

    get :index, :user_id => "1"
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @memberships" do
    assigns[:memberships].should == [] 
  end

  it "should set @user" do
    assigns[:user].should == @user 
  end
end

describe MembershipsController, "handling GET /users/1/memberships/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @user = mock_model(User)
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

describe MembershipsController, "handling GET /users/1/memberships/new as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @user = mock_model(User)
    User.stub!(:find).and_return(@user)
    Group.stub!(:find).and_return([])
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
    assigns[:groups].should == [] 
  end
end

describe MembershipsController, "handling POST /users/1/permissions as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @membership.stub!(:save).and_return(true)
    @user = mock_model(User)
    User.stub!(:find).and_return(@user)
    Group.stub!(:find).and_return([])
    @membership_association = stub("association", :build => @membership)
    @user.stub!(:memberships).and_return(@membership_association)
  end

  it "should redirect to /users/:id/memberships/:id when valid" do
    post :create, :user_id => "1"
    response.should redirect_to(user_membership_url(@user, @membership))
  end

  it "should render 'new' when invalid" do
    @membership.stub!(:save).and_return(false)

    post :create, :user_id => "1"
    response.should render_template("new")
  end

  it "should set @membership" do
    post :create, :user_id => "1"
    assigns[:membership].should == @membership
  end

  it "should set @user" do
    get :new, :user_id => "1"
    assigns[:user].should == @user
  end

  it "should set @groups" do
    get :new, :user_id => "1"
    assigns[:groups].should == [] 
  end
end

describe MembershipsController, "handling DELETE /users/1/memberships/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    login_as(:admin)
    @membership = mock_model(Membership)
    @memberships = [@membership]
    @user = mock_model(User)
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

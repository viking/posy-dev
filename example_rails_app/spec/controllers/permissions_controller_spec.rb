require File.dirname(__FILE__) + '/../spec_helper'

describe PermissionsController do
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
      @permission = mock_model(Permission)
      @group = mock_model(Group)
    end

    describe "handling GET /permissions/" do

      before(:each) do
        Permission.stub!(:find).and_return([@permission])

        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @permissions" do
        assigns[:permissions].should == [@permission]
      end
    end

    describe "handling GET /permissions/1" do

      before(:each) do
        Permission.stub!(:find).and_return(@permission)

        get :show, :id => "1"
      end

      it "should be successfully" do
        response.should be_success
      end

      it "should set @permission" do
        assigns[:permission].should == @permission
      end
    end

    describe "handling GET /permissions/1/edit" do

      before(:each) do
        Permission.stub!(:find).and_return(@permission)

        get :edit, :id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @permission" do
        assigns[:permission].should == @permission
      end
    end

    describe "handling GET /permissions/new" do

      before(:each) do
        @resource_types = %w{Lion Tiger Bear}
        Permission.stub!(:new).and_return(@permission)
        Group.stub!(:find).and_return([@group])
        Posy.stub!(:models).and_return(@resource_types)
      end

      it "should be successful" do
        get :new
        response.should be_success
      end

      it "should render template 'new'" do
        get :new
        response.should render_template('new')
      end

      it "should set @permission" do
        get :new
        assigns[:permission].should == @permission
      end

      it "should set @groups" do
        get :new
        assigns[:groups].should == [@group] 
      end

      it "should set @resource_types" do
        get :new
        assigns[:resource_types].should == ['Controller'] + @resource_types
      end

      it "should call Posy.models" do
        Posy.should_receive(:models).and_return(@resource_types)
        get :new
      end
    end

    describe "handling GET /permissions/new.js" do

      before(:each) do
        Permission.stub!(:new).and_return(@permission)
        Group.stub!(:find).and_return([@group])
      end

      it "should be successful" do
        get :new, :format => 'js'
        response.should be_success
      end

      it "should render template 'new.rjs'" do
        get :new, :format => 'js'
        response.should render_template('new.rjs')
      end

      it "should set @controllers when params[:permission][:resource_type] is 'Controller'" do
        Posy.stub!(:controllers).and_return(%w{vampires})
        
        get :new, :format => 'js', :permission => { :resource_type => 'Controller' }
        assigns[:controllers].should == %w{vampires}
      end

      it "should set @resources when params[:permission][:resource_type] is 'Pocky'" do
        @pockys = Array.new(5) { |i| Pocky.new(i+1) }
        Pocky.stub!(:find).and_return(@pockys)

        get :new, :format => 'js', :permission => { :resource_type => 'Pocky' }
        assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
      end
    end

    describe "handling POST /permissions/" do

      before(:each) do
        @resource_types = %w{Lion Tiger Bear}

        Permission.stub!(:new).and_return(@permission)
        Group.stub!(:find).and_return([@group])
        @permission.stub!(:save).and_return(true)
        @permission.stub!(:controller).and_return(nil)
        Posy.stub!(:models).and_return(@resource_types)
      end
      
      it "should redirect to /permissions/:id when valid" do
        post :create
        response.should redirect_to(permission_url(@permission))
      end

      it "should render 'new' when invalid" do
        @permission.stub!(:save).and_return(false)
        post :create
        response.should render_template("new")
      end

      it "should set @resource_types when invalid" do
        @permission.stub!(:save).and_return(false)
        post :create
        assigns[:resource_types].should == ['Controller'] + @resource_types
      end

      it "should set @permission" do
        post :create
        assigns[:permission].should == @permission
      end

      it "should set @groups" do
        post :create
        assigns[:groups].should == [@group] 
      end

      it "should set @permission's resource_type to nil when @permission.controller exists" do
        @permission.stub!(:controller).and_return("vampires")

        @permission.should_receive(:resource_type=).with(nil)
        post :create
      end

      it "should set @controllers when invalid and params[:permission][:resource_type] is 'Controller'" do
        @permission.stub!(:save).and_return(false)
        Posy.stub!(:controllers).and_return(%w{vampires})
        
        post :create, :permission => { :resource_type => 'Controller' }
        assigns[:controllers].should == %w{vampires}
      end

      it "should set @resources when invalid params[:permission][:resource_type] is 'Pocky'" do
        @permission.stub!(:save).and_return(false)
        @pockys = Array.new(5) { |i| Pocky.new(i+1) }
        Pocky.stub!(:find).and_return(@pockys)

        post :create, :permission => { :resource_type => 'Pocky' }
        assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
      end
    end

    describe "handling PUT /permissions/1" do

      before(:each) do
        Permission.stub!(:find).and_return(@permission)
        Group.stub!(:find).and_return([@group])
        @permission.stub!(:update_attributes).and_return(true)
        @permission.stub!(:controller).and_return(nil)
      end
      
      it "should redirect to /permissions/:id when valid" do
        put :update, :id => "1", :permission => { }
        response.should redirect_to(permission_url(@permission))
      end

      it "should render 'edit' when invalid" do
        @permission.stub!(:update_attributes).and_return(false)
        put :update, :id => "1", :permission => { }
        response.should render_template("edit")
      end

      it "should set @permission" do
        put :update, :id => "1", :permission => { }
        assigns[:permission].should == @permission
      end

      it "should remove all parameters except can_read, can_write, and is_sticky" do
        put :update, :id => "1", :permission => { 
          :partical => "man", 
          :triangle => "man", 
          :can_read => true, 
          :can_write => true, 
          :is_sticky => true
        }
        @controller.params[:permission].keys.sort.should == %w{can_read can_write is_sticky}
      end
    end

    describe "handling DELETE /permissions/1" do

      before(:each) do
        Permission.stub!(:find).and_return(@permission)
        @permission.stub!(:destroy).and_return(@permission)
      end

      it "should redirect to /permissions" do
        delete :destroy, :id => '1'
        response.should redirect_to(permissions_url)
      end

      it "should set @permission" do
        delete :destroy, :id => '1'
        assigns[:permission].should == @permission
      end
    end

    describe "handling GET /groups/1/permissions/" do

      before(:each) do
        @group.stub!(:permissions).and_return([@permission])
        Group.stub!(:find).and_return(@group)

        get :index, :group_id => '1'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @permissions" do
        assigns[:permissions].should == [@permission]
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/1/permissions/1" do

      before(:each) do
        @permission_association = stub("association", :find => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)

        get :show, :id => "1", :group_id => '1'
      end

      it "should be successfully" do
        response.should be_success
      end

      it "should set @permission" do
        assigns[:permission].should == @permission
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/1/permissions/1/edit" do

      before(:each) do
        @permission_association = stub("association", :find => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)

        get :edit, :id => "1", :group_id => '1'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @permission" do
        assigns[:permission].should == @permission
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/1/permissions/new" do

      before(:each) do
        @permission_association = stub("association", :build => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)

        get :new, :group_id => '1'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should render template 'new'" do
        response.should render_template('new')
      end

      it "should set @permission" do
        assigns[:permission].should == @permission
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end

    describe "handling GET /groups/1/permissions/new.js" do

      before(:each) do
        @permission_association = stub("association", :build => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)
      end

      it "should be successful" do
        get :new, :format => 'js', :group_id => '1'
        response.should be_success
      end

      it "should render template 'new.rjs'" do
        get :new, :format => 'js', :group_id => '1'
        response.should render_template('new.rjs')
      end

      it "should set @controllers when params[:permission][:resource_type] is 'Controller'" do
        Posy.stub!(:controllers).and_return(%w{vampires})
        
        get :new, :format => 'js', :group_id => '1', :permission => { :resource_type => 'Controller' }
        assigns[:controllers].should == %w{vampires}
      end

      it "should set @resources when params[:permission][:resource_type] is 'Pocky'" do
        @pockys = Array.new(5) { |i| Pocky.new(i+1) }
        Pocky.stub!(:find).and_return(@pockys)

        get :new, :format => 'js', :group_id => '1', :permission => { :resource_type => 'Pocky' }
        assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
      end
    end

    describe "handling POST /groups/1/permissions/" do

      before(:each) do
        @permission_association = stub("association", :build => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)
        @permission.stub!(:save).and_return(true)
        @permission.stub!(:controller).and_return(nil)
      end
      
      it "should redirect to /groups/1/permissions/:id when valid" do
        post :create, :group_id => '1'
        response.should redirect_to(group_permission_url(@group, @permission))
      end

      it "should render 'new' when invalid" do
        @permission.stub!(:save).and_return(false)
        post :create, :group_id => '1'
        response.should render_template("new")
      end

      it "should set @permission" do
        post :create, :group_id => '1'
        assigns[:permission].should == @permission
      end

      it "should set @group" do
        post :create, :group_id => '1'
        assigns[:group].should == @group
      end

      it "should set @permission's resource_type to nil when @permission.controller exists" do
        @permission.stub!(:controller).and_return("vampires")

        @permission.should_receive(:resource_type=).with(nil)
        post :create, :group_id => '1'
      end

      it "should set @controllers when invalid and params[:permission][:resource_type] is 'Controller'" do
        @permission.stub!(:save).and_return(false)
        Posy.stub!(:controllers).and_return(%w{vampires})
        
        post :create, :permission => { :resource_type => 'Controller' }
        assigns[:controllers].should == %w{vampires}
      end

      it "should set @resources when invalid params[:permission][:resource_type] is 'Pocky'" do
        @permission.stub!(:save).and_return(false)
        @pockys = Array.new(5) { |i| Pocky.new(i+1) }
        Pocky.stub!(:find).and_return(@pockys)

        post :create, :permission => { :resource_type => 'Pocky' }
        assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
      end
    end

    describe "handling PUT /groups/1/permissions/1" do

      before(:each) do
        @permission_association = stub("association", :find => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)
        @permission.stub!(:update_attributes).and_return(true)
        @permission.stub!(:controller).and_return(nil)
      end
      
      it "should redirect to /groups/1/permissions/:id when valid" do
        put :update, :id => "1", :group_id => '1', :permission => { }
        response.should redirect_to(group_permission_url(@group, @permission))
      end

      it "should render 'edit' when invalid" do
        @permission.stub!(:update_attributes).and_return(false)
        put :update, :id => "1", :group_id => '1', :permission => { }
        response.should render_template("edit")
      end

      it "should set @permission" do
        put :update, :id => "1", :group_id => '1', :permission => { }
        assigns[:permission].should == @permission
      end

      it "should set @group" do
        put :update, :id => "1", :group_id => '1', :permission => { }
        assigns[:group].should == @group
      end

      it "should remove all parameters except can_read, can_write, and is_sticky" do
        put :update, :id => "1", :group_id => '1', :permission => { 
          :partical => "man", 
          :triangle => "man", 
          :can_read => true, 
          :can_write => true, 
          :is_sticky => true
        }
        @controller.params[:permission].keys.sort.should == %w{can_read can_write is_sticky}
      end
    end

    describe "handling DELETE /groups/1/permissions/1" do

      before(:each) do
        @permission_association = stub("association", :find => @permission)
        @group.stub!(:permissions).and_return(@permission_association)
        Group.stub!(:find).and_return(@group)
        @permission.stub!(:destroy).and_return(@permission)

        delete :destroy, :id => '1', :group_id => '1'
      end

      it "should redirect to /groups/1/permissions" do
        response.should redirect_to(group_permissions_url(@group))
      end

      it "should set @permission" do
        assigns[:permission].should == @permission
      end

      it "should set @group" do
        assigns[:group].should == @group
      end
    end
  end
end

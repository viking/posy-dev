require File.dirname(__FILE__) + '/../spec_helper'

describe CatsController do
  include AuthenticatedTestHelper
  fixtures :users, :groups, :memberships, :permissions, :cats

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
    end

    describe "handling GET /cats" do

      before(:each) do
        @cat = mock_model(Cat)
        Cat.stub!(:find).and_return([@cat])
      end
    
      def do_get
        get :index
      end
    
      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render index template" do
        do_get
        response.should render_template('index')
      end
    
      it "should find all cats" do
        Cat.should_receive(:find).with(:all).and_return([@cat])
        do_get
      end
    
      it "should assign the found cats for the view" do
        do_get
        assigns[:cats].should == [@cat]
      end
    end

    describe "handling GET /cats.xml" do

      before(:each) do
        @cats = mock("Array of Cats", :to_xml => "XML")
        Cat.stub!(:find).and_return(@cats)
      end
    
      def do_get
        @request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
      end
    
      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should find all cats" do
        Cat.should_receive(:find).with(:all).and_return(@cats)
        do_get
      end
    
      it "should render the found cats as xml" do
        @cats.should_receive(:to_xml).and_return("XML")
        do_get
        response.body.should == "XML"
      end
    end

    describe "handling GET /cats/1" do

      before(:each) do
        @cat = mock_model(Cat)
        Cat.stub!(:find).and_return(@cat)
      end
    
      def do_get
        get :show, :id => "1"
      end

      it "should be successful" do
        do_get
        response.should be_success
      end
    
      it "should render show template" do
        do_get
        response.should render_template('show')
      end
    
      it "should find the cat requested" do
        Cat.should_receive(:find).with("1").and_return(@cat)
        do_get
      end
    
      it "should assign the found cat for the view" do
        do_get
        assigns[:cat].should equal(@cat)
      end
    end

    describe "handling GET /cats/1.xml" do

      before(:each) do
        @cat = mock_model(Cat, :to_xml => "XML")
        Cat.stub!(:find).and_return(@cat)
      end
    
      def do_get
        @request.env["HTTP_ACCEPT"] = "application/xml"
        get :show, :id => "1"
      end

      it "should be successful" do
        do_get
        response.should be_success
      end
    
      it "should find the cat requested" do
        Cat.should_receive(:find).with("1").and_return(@cat)
        do_get
      end
    
      it "should render the found cat as xml" do
        @cat.should_receive(:to_xml).and_return("XML")
        do_get
        response.body.should == "XML"
      end
    end

    describe "handling GET /cats/new" do

      before(:each) do
        @cat = mock_model(Cat)
        Cat.stub!(:new).and_return(@cat)
      end
    
      def do_get
        get :new
      end

      it "should be successful" do
        do_get
        response.should be_success
      end
    
      it "should render new template" do
        do_get
        response.should render_template('new')
      end
    
      it "should create an new cat" do
        Cat.should_receive(:new).and_return(@cat)
        do_get
      end
    
      it "should not save the new cat" do
        @cat.should_not_receive(:save)
        do_get
      end
    
      it "should assign the new cat for the view" do
        do_get
        assigns[:cat].should equal(@cat)
      end
    end

    describe "handling GET /cats/1/edit" do

      before(:each) do
        @cat = mock_model(Cat)
        Cat.stub!(:find).and_return(@cat)
      end
    
      def do_get
        get :edit, :id => "1"
      end

      it "should be successful" do
        do_get
        response.should be_success
      end
    
      it "should render edit template" do
        do_get
        response.should render_template('edit')
      end
    
      it "should find the cat requested" do
        Cat.should_receive(:find).and_return(@cat)
        do_get
      end
    
      it "should assign the found Cat for the view" do
        do_get
        assigns[:cat].should equal(@cat)
      end
    end

    describe "handling POST /cats" do

      before(:each) do
        @cat = mock_model(Cat, :to_param => "1")
        Cat.stub!(:new).and_return(@cat)
      end
      
      describe "with successful save" do
    
        def do_post
          @cat.should_receive(:save).and_return(true)
          post :create, :cat => {}
        end
    
        it "should create a new cat" do
          Cat.should_receive(:new).with({}).and_return(@cat)
          do_post
        end

        it "should redirect to the new cat" do
          do_post
          response.should redirect_to(cat_url("1"))
        end
        
      end
      
      describe "with failed save" do

        def do_post
          @cat.should_receive(:save).and_return(false)
          post :create, :cat => {}
        end
    
        it "should re-render 'new'" do
          do_post
          response.should render_template('new')
        end
        
      end
    end

    describe "handling PUT /cats/1" do

      before(:each) do
        @cat = mock_model(Cat, :to_param => "1")
        Cat.stub!(:find).and_return(@cat)
      end
      
      describe "with successful update" do

        def do_put
          @cat.should_receive(:update_attributes).and_return(true)
          put :update, :id => "1"
        end

        it "should find the cat requested" do
          Cat.should_receive(:find).with("1").and_return(@cat)
          do_put
        end

        it "should update the found cat" do
          do_put
          assigns(:cat).should equal(@cat)
        end

        it "should assign the found cat for the view" do
          do_put
          assigns(:cat).should equal(@cat)
        end

        it "should redirect to the cat" do
          do_put
          response.should redirect_to(cat_url("1"))
        end

      end
      
      describe "with failed update" do

        def do_put
          @cat.should_receive(:update_attributes).and_return(false)
          put :update, :id => "1"
        end

        it "should re-render 'edit'" do
          do_put
          response.should render_template('edit')
        end

      end
    end

    describe "handling DELETE /cats/1" do

      before(:each) do
        @cat = mock_model(Cat, :destroy => true)
        Cat.stub!(:find).and_return(@cat)
      end
    
      def do_delete
        delete :destroy, :id => "1"
      end

      it "should find the cat requested" do
        Cat.should_receive(:find).with("1").and_return(@cat)
        do_delete
      end
    
      it "should call destroy on the found cat" do
        @cat.should_receive(:destroy)
        do_delete
      end
    
      it "should redirect to the cats list" do
        do_delete
        response.should redirect_to(cats_url)
      end
    end
  end

  describe "when logged in as a read-only user" do

    before(:each) do
      login_as(:cat_reader)
    end

    it "should GET /cats successfully" do
      get :index
      response.should be_success
    end
    
    it "should GET /cats/1 successfully" do
      get :show, :id => "1"
      response.should be_success
    end

    it "should fail GET /cats/new" do
      get :new
      response.should be_unauthorized 
    end

    it "should fail GET /cats/1/edit" do
      get :edit, :id => "1"
      response.should be_unauthorized 
    end

    it "should fail POST /cats" do
      post :create, :cat => {} 
      response.should be_unauthorized 
    end

    it "should fail PUT /cats/1" do
      put :update, :id => "1" 
      response.should be_unauthorized 
    end

    it "should fail DELETE /cats/1" do
      delete :destroy, :id => "1" 
      response.should be_unauthorized 
    end
  end

  describe "when logged in as a write-only user" do

    before(:each) do
      login_as(:cat_writer)
    end

    it "should fail GET /cats" do
      get :index
      response.should be_unauthorized
    end
    
    it "should fail GET /cats/1" do
      get :show, :id => "1"
      response.should be_unauthorized
    end

    it "should GET /cats/new successfully" do
      get :new
      response.should be_success 
    end

    it "should fail GET /cats/1/edit" do
      get :edit, :id => "1"
      response.should be_unauthorized 
    end

    it "should POST /cats successfully" do
      post :create, :cat => {} 
      response.should be_redirect 
    end

    it "should PUT /cats/1 successfully" do
      put :update, :id => "1" 
      response.should be_redirect 
    end

    it "should DELETE /cats/1 successfully" do
      delete :destroy, :id => "1" 
      response.should be_redirect 
    end
  end

  describe "when logged in as a read and write user" do

    before(:each) do
      login_as(:cat_admin)
    end

    it "should GET /cats successfully" do
      get :index
      response.should be_success
    end
    
    it "should GET /cats/1 successfully" do
      get :show, :id => "1"
      response.should be_success
    end

    it "should GET /cats/new successfully" do
      get :new
      response.should be_success 
    end

    it "should GET /cats/1/edit successfully" do
      get :edit, :id => "1"
      response.should be_success 
    end

    it "should POST /cats successfully" do
      post :create, :cat => {} 
      response.should be_redirect 
    end

    it "should PUT /cats/1 successfully" do
      put :update, :id => "1" 
      response.should be_redirect 
    end

    it "should DELETE /cats/1 successfully" do
      delete :destroy, :id => "1" 
      response.should be_redirect 
    end
  end

  describe "when logged in as user with read-only access to fluffy" do
    before(:each) do
      login_as(:fluffy_reader)
    end

    it "should fail GET /cats" do
      get :index
      response.should be_unauthorized
    end
    
    it "should GET /cats/1 successfully" do
      get :show, :id => "1"
      response.should be_success
    end

    it "should fail GET /cats/2" do
      get :show, :id => "2"
      response.should be_unauthorized
    end

    it "should fail GET /cats/new" do
      get :new
      response.should be_unauthorized 
    end

    it "should fail GET /cats/1/edit" do
      get :edit, :id => "1"
      response.should be_unauthorized 
    end

    it "should fail POST /cats" do
      post :create, :cat => {} 
      response.should be_unauthorized 
    end

    it "should fail PUT /cats/1" do
      put :update, :id => "1" 
      response.should be_unauthorized 
    end

    it "should fail DELETE /cats/1" do
      delete :destroy, :id => "1" 
      response.should be_unauthorized 
    end
  end

  describe "when logged in as user with write-only access to fluffy" do
    before(:each) do
      login_as(:fluffy_writer)
    end

    it "should fail GET /cats" do
      get :index
      response.should be_unauthorized
    end
    
    it "should fail GET /cats/1" do
      get :show, :id => "1"
      response.should be_unauthorized
    end

    it "should fail GET /cats/new" do
      get :new
      response.should be_unauthorized 
    end

    it "should fail GET /cats/1/edit" do
      get :edit, :id => "1"
      response.should be_unauthorized 
    end

    it "should fail POST /cats" do
      post :create, :cat => {} 
      response.should be_unauthorized 
    end

    it "should PUT /cats/1 successfully" do
      put :update, :id => "1" 
      response.should be_redirect 
    end

    it "should fail PUT /cats/2" do
      put :update, :id => "2" 
      response.should be_unauthorized 
    end

    it "should DELETE /cats/1 successfully" do
      delete :destroy, :id => "1" 
      response.should be_redirect 
    end

    it "should fail DELETE /cats/2" do
      delete :destroy, :id => "2" 
      response.should be_unauthorized 
    end
  end

  describe "when logged in as user with read and write access to fluffy" do
    before(:each) do
      login_as(:fluffy_admin)
    end

    it "should fail GET /cats" do
      get :index
      response.should be_unauthorized
    end
    
    it "should GET /cats/1 successfully" do
      get :show, :id => "1"
      response.should be_success
    end

    it "should fails GET /cats/2" do
      get :show, :id => "2"
      response.should be_unauthorized
    end

    it "should fail GET /cats/new" do
      get :new
      response.should be_unauthorized 
    end

    it "should GET /cats/1/edit successfully" do
      get :edit, :id => "1"
      response.should be_success 
    end

    it "should fail GET /cats/1/edit" do
      get :edit, :id => "2"
      response.should be_unauthorized 
    end

    it "should fail POST /cats" do
      post :create, :cat => {} 
      response.should be_unauthorized 
    end

    it "should PUT /cats/1 successfully" do
      put :update, :id => "1" 
      response.should be_redirect 
    end

    it "should fail PUT /cats/2" do
      put :update, :id => "2" 
      response.should be_unauthorized 
    end

    it "should DELETE /cats/1 successfully" do
      delete :destroy, :id => "1" 
      response.should be_redirect 
    end

    it "should fail DELETE /cats/2" do
      delete :destroy, :id => "2" 
      response.should be_unauthorized 
    end
  end

  describe "when logged in as a user with rw+t access to cats" do
    it "should do what I think it should, dammit!"
  end
end

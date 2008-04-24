require File.dirname(__FILE__) + '/../spec_helper'

describe DogsController do
  describe "handling GET /dogs" do

    before(:each) do
      @dog = mock_model(Dog)
      Dog.stub!(:find).and_return([@dog])
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
  
    it "should find all dogs" do
      Dog.should_receive(:find).with(:all).and_return([@dog])
      do_get
    end
  
    it "should assign the found dogs for the view" do
      do_get
      assigns[:dogs].should == [@dog]
    end
  end

  describe "handling GET /dogs.xml" do

    before(:each) do
      @dogs = mock("Array of Dogs", :to_xml => "XML")
      Dog.stub!(:find).and_return(@dogs)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all dogs" do
      Dog.should_receive(:find).with(:all).and_return(@dogs)
      do_get
    end
  
    it "should render the found dogs as xml" do
      @dogs.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /dogs/1" do

    before(:each) do
      @dog = mock_model(Dog)
      Dog.stub!(:find).and_return(@dog)
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
  
    it "should find the dog requested" do
      Dog.should_receive(:find).with("1").and_return(@dog)
      do_get
    end
  
    it "should assign the found dog for the view" do
      do_get
      assigns[:dog].should equal(@dog)
    end
  end

  describe "handling GET /dogs/1.xml" do

    before(:each) do
      @dog = mock_model(Dog, :to_xml => "XML")
      Dog.stub!(:find).and_return(@dog)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the dog requested" do
      Dog.should_receive(:find).with("1").and_return(@dog)
      do_get
    end
  
    it "should render the found dog as xml" do
      @dog.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /dogs/new" do

    before(:each) do
      @dog = mock_model(Dog)
      Dog.stub!(:new).and_return(@dog)
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
  
    it "should create an new dog" do
      Dog.should_receive(:new).and_return(@dog)
      do_get
    end
  
    it "should not save the new dog" do
      @dog.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new dog for the view" do
      do_get
      assigns[:dog].should equal(@dog)
    end
  end

  describe "handling GET /dogs/1/edit" do

    before(:each) do
      @dog = mock_model(Dog)
      Dog.stub!(:find).and_return(@dog)
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
  
    it "should find the dog requested" do
      Dog.should_receive(:find).and_return(@dog)
      do_get
    end
  
    it "should assign the found Dog for the view" do
      do_get
      assigns[:dog].should equal(@dog)
    end
  end

  describe "handling POST /dogs" do

    before(:each) do
      @dog = mock_model(Dog, :to_param => "1")
      Dog.stub!(:new).and_return(@dog)
    end
    
    describe "with successful save" do
  
      def do_post
        @dog.should_receive(:save).and_return(true)
        post :create, :dog => {}
      end
  
      it "should create a new dog" do
        Dog.should_receive(:new).with({}).and_return(@dog)
        do_post
      end

      it "should redirect to the new dog" do
        do_post
        response.should redirect_to(dog_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @dog.should_receive(:save).and_return(false)
        post :create, :dog => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /dogs/1" do

    before(:each) do
      @dog = mock_model(Dog, :to_param => "1")
      Dog.stub!(:find).and_return(@dog)
    end
    
    describe "with successful update" do

      def do_put
        @dog.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the dog requested" do
        Dog.should_receive(:find).with("1").and_return(@dog)
        do_put
      end

      it "should update the found dog" do
        do_put
        assigns(:dog).should equal(@dog)
      end

      it "should assign the found dog for the view" do
        do_put
        assigns(:dog).should equal(@dog)
      end

      it "should redirect to the dog" do
        do_put
        response.should redirect_to(dog_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @dog.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /dogs/1" do

    before(:each) do
      @dog = mock_model(Dog, :destroy => true)
      Dog.stub!(:find).and_return(@dog)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the dog requested" do
      Dog.should_receive(:find).with("1").and_return(@dog)
      do_delete
    end
  
    it "should call destroy on the found dog" do
      @dog.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the dogs list" do
      do_delete
      response.should redirect_to(dogs_url)
    end
  end
end
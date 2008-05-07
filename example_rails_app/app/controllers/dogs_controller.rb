class DogsController < ApplicationController
  before_filter :login_required
  access_hierarchies [:people]

  # GET /dogs
  # GET /dogs.xml
  def index
    @dogs = Dog.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @dogs.to_xml }
    end
  end

  # GET /dogs/1
  # GET /dogs/1.xml
  def show
    @dog = Dog.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @dog.to_xml }
    end
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1;edit
  def edit
    @dog = Dog.find(params[:id])
  end

  # POST /dogs
  # POST /dogs.xml
  def create
    @dog = Dog.new(params[:dog])

    respond_to do |format|
      if @dog.save
        flash[:notice] = 'Dog was successfully created.'
        format.html { redirect_to dog_url(@dog) }
        format.xml  { head :created, :location => dog_url(@dog) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dog.errors.to_xml }
      end
    end
  end

  # PUT /dogs/1
  # PUT /dogs/1.xml
  def update
    @dog = Dog.find(params[:id])

    respond_to do |format|
      if @dog.update_attributes(params[:dog])
        flash[:notice] = 'Dog was successfully updated.'
        format.html { redirect_to dog_url(@dog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dog.errors.to_xml }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.xml
  def destroy
    @dog = Dog.find(params[:id])
    @dog.destroy

    respond_to do |format|
      format.html { redirect_to dogs_url }
      format.xml  { head :ok }
    end
  end
end

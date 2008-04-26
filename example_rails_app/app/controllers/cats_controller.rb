class CatsController < ApplicationController
  before_filter :login_required

  # GET /cats
  # GET /cats.xml
  def index
    @cats = Cat.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @cats.to_xml }
    end
  end

  # GET /cats/1
  # GET /cats/1.xml
  def show
    @cat = Cat.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @cat.to_xml }
    end
  end

  # GET /cats/new
  def new
    @cat = Cat.new
  end

  # GET /cats/1;edit
  def edit
    @cat = Cat.find(params[:id])
  end

  # POST /cats
  # POST /cats.xml
  def create
    @cat = Cat.new(params[:cat])

    respond_to do |format|
      if @cat.save
        flash[:notice] = 'Cat was successfully created.'
        format.html { redirect_to cat_url(@cat) }
        format.xml  { head :created, :location => cat_url(@cat) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cat.errors.to_xml }
      end
    end
  end

  # PUT /cats/1
  # PUT /cats/1.xml
  def update
    @cat = Cat.find(params[:id])

    respond_to do |format|
      if @cat.update_attributes(params[:cat])
        flash[:notice] = 'Cat was successfully updated.'
        format.html { redirect_to cat_url(@cat) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cat.errors.to_xml }
      end
    end
  end

  # DELETE /cats/1
  # DELETE /cats/1.xml
  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy

    respond_to do |format|
      format.html { redirect_to cats_url }
      format.xml  { head :ok }
    end
  end
end

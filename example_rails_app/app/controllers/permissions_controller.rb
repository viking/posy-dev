class PermissionsController < ApplicationController
  prepend_before_filter :login_required

  # GET /permissions
  # GET /permissions.xml
  def index
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permissions = @group.permissions
    else
      @permissions = Permission.find(:all)
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @permissions.to_xml }
    end
  end

  # GET /permissions/1
  # GET /permissions/1.xml
  def show
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permission = @group.permissions.find(params[:id])
    else
      @permission = Permission.find(params[:id])
    end

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @permission.to_xml }
    end
  end

  # GET /permissions/new
  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permission = @group.permissions.build
    else
      @groups = Group.find(:all)
      @permission = Permission.new
    end
    @resource_types = ['Controller'] + Posy.models

    respond_to do |format|
      format.html # new.rhtml
      format.js do
        setup_resources_or_controllers
        render :action => 'new.rjs'
      end
    end
  end

  # GET /permissions/1;edit
  def edit
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permission = @group.permissions.find(params[:id])
    else
      @permission = Permission.find(params[:id])
    end
  end

  # POST /permissions
  # POST /permissions.xml
  def create
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permission = @group.permissions.build(params[:permission])
    else
      @groups = Group.find(:all)
      @permission = Permission.new(params[:permission])
    end
    
    # remove resource_type if 'Controller'
    @permission.resource_type = nil   if @permission.controller

    respond_to do |format|
      if @permission.save
        flash[:notice] = 'Permission was successfully created.'
        format.html do
          if @group
            redirect_to group_permission_url(@group, @permission)
          else
            redirect_to permission_url(@permission)
          end
        end
        format.xml  { head :created, :location => permission_url(@permission) }
      else
        format.html do
          @resource_types = ['Controller'] + Posy.models
          setup_resources_or_controllers
          render :action => "new"
        end
        format.xml  { render :xml => @permission.errors.to_xml }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permission = @group.permissions.find(params[:id])
    else
      @permission = Permission.find(params[:id])
    end

    # remove all params except read/write/sticky
    params[:permission].delete_if { |k, v| !%w{can_read can_write is_sticky}.include?(k) }

    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        flash[:notice] = 'Permission was successfully updated.'
        format.html do
          if @group
            redirect_to group_permission_url(@group, @permission)
          else
            redirect_to permission_url(@permission)
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @permission.errors.to_xml }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.xml
  def destroy
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @permission = @group.permissions.find(params[:id])
    else
      @permission = Permission.find(params[:id])
    end
    @permission.destroy

    respond_to do |format|
      format.html do
        if @group
          redirect_to group_permissions_url(@group)
        else
          redirect_to permissions_url
        end
      end
      format.xml  { head :ok }
    end
  end

  protected
    def setup_resources_or_controllers
      type = params[:permission][:resource_type]  rescue nil
      case type
      when 'Controller'
        @controllers = Posy.controllers 
      when /[A-Z]\w+/
        @resources = type.constantize.find(:all).collect { |x| [x.name, x.id] }
      end
    end
end

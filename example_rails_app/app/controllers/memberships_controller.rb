class MembershipsController < ApplicationController
  prepend_before_filter :login_required

  # GET /memberships
  # GET /memberships.xml
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @memberships = @user.memberships
    elsif params[:group_id]
      @group = Group.find(params[:group_id])
      @memberships = @group.memberships
    else
      @memberships = Membership.find(:all)
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @memberships.to_xml }
    end
  end

  # GET /memberships/1
  # GET /memberships/1.xml
  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      @membership = @user.memberships.find(params[:id])
    elsif params[:group_id]
      @group = Group.find(params[:group_id])
      @membership = @group.memberships.find(params[:id])
    else
      @membership = Membership.find(params[:id])
    end

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @membership.to_xml }
    end
  end

  # GET /memberships/new
  def new
    if params[:user_id]
      @user = User.find(params[:user_id])
      @membership = @user.memberships.build
      @groups = Group.find(:all)
    elsif params[:group_id]
      @group = Group.find(params[:group_id])
      @membership = @group.memberships.build
      @users = User.find(:all)
    else
      @membership = Membership.new
      @users = User.find(:all)
      @groups = Group.find(:all)
    end
  end

  # POST /memberships
  # POST /memberships.xml
  def create
    if params[:user_id]
      @user = User.find(params[:user_id])
      @membership = @user.memberships.build(params[:membership])
      @groups = Group.find(:all)
    elsif params[:group_id]
      @group = Group.find(params[:group_id])
      @membership = @group.memberships.build(params[:membership])
      @users = User.find(:all)
    else
      @membership = Membership.new(params[:membership])
      @users = User.find(:all)
      @groups = Group.find(:all)
    end

    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership was successfully created.'
        format.html do 
          if @user
            redirect_to user_membership_url(@user, @membership)
          elsif @group
            redirect_to group_membership_url(@group, @membership)
          else
            redirect_to membership_url(@membership)
          end
        end
        format.xml  { head :created, :location => membership_url(@membership) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @membership.errors.to_xml }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.xml
  def destroy
    if params[:user_id]
      @user = User.find(params[:user_id])
      @membership = @user.memberships.find(params[:id])
    elsif params[:group_id]
      @group = Group.find(params[:group_id])
      @membership = @group.memberships.find(params[:id])
    else
      @membership = Membership.find(params[:id])
    end
    @membership.destroy

    respond_to do |format|
      format.html do 
        if @user
          redirect_to user_memberships_url(@user)
        elsif @group
          redirect_to group_memberships_url(@group)
        else
          redirect_to memberships_url
        end
      end
      format.xml  { head :ok }
    end
  end
end

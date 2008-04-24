require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /groups/show" do
  before do
    @group = mock_model(Group, {
      :name => "foo", :description => "the foo group", :permanent => false, 
      :created_at => Time.now, :updated_at => Time.now, :creator => nil, :updater => nil
    })

    @user = mock_model(User, :login => 'dude', :email => 'guy@dudes.com')
    @users = Array.new(3, @user)
    @group.stub!(:users).and_return(@users)

    @pocky = Pocky.new
    @resource_permission = mock_model(Permission, {
      :can_read => true, :can_write => false, :is_sticky => true, 
      :controller => nil, :resource => @pocky
    })
    @controller_permission = mock_model(Permission, {
      :can_read => true, :can_write => false, :is_sticky => true, 
      :controller => "pockies"
    })
    @permissions = [@resource_permission, @controller_permission]
    @group.stub!(:permissions).and_return(@permissions)

    assigns[:group] = @group
  end
  
  it "should not raise an error" do
    lambda { render 'groups/show' }.should_not raise_error
  end
end

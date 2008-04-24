require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /permissions/index" do
  before do
    @group = mock_model(Group, :name => "dudes")
    @pocky = Pocky.new
    @pocky.stub!(:name).and_return('teh p0cky')
    @controller_permission = mock_model(Permission, {
      :group => @group, :controller => "vampires", :can_read => true,
      :can_write => true, :is_sticky => false
    })
    @resource_permission = mock_model(Permission, {
      :group => @group, :controller => nil, :resource => @pocky,
      :can_read => true, :can_write => true, :is_sticky => false
    })
    @permissions = [@controller_permission, @resource_permission]
    assigns[:permissions] = @permissions
  end
 
  it "should not raise an error" do
    lambda { render '/permissions/index' }.should_not raise_error
  end

  it "should call resource_link twice" do
    @controller.template.should_receive(:resource_link).exactly(2).times
    render '/permissions/index'
  end
end

describe "rendering /permissions/index when @group is set" do
  before do
    @group = mock_model(Group, :name => "dudes")
    @pocky = Pocky.new
    @pocky.stub!(:name).and_return('teh p0cky')
    @controller_permission = mock_model(Permission, {
      :group => @group, :controller => "vampires", :can_read => true,
      :can_write => true, :is_sticky => false
    })
    @resource_permission = mock_model(Permission, {
      :group => @group, :controller => nil, :resource => @pocky,
      :can_read => true, :can_write => true, :is_sticky => false
    })
    @permissions = [@controller_permission, @resource_permission]
    assigns[:permissions] = @permissions
    assigns[:group] = @group
  end
 
  it "should not raise an error" do
    lambda { render '/permissions/index' }.should_not raise_error
  end

  it "should have a back link to group_path(@group)" do
    render '/permissions/index'
    url = group_path(@group)
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

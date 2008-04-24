require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /permissions/show for a controller permission" do
  before do
    @group = mock_model(Group, :name => 'dudes')
    @permission = mock_model(Permission, {
      :group => @group, :controller => 'vampires', :can_read => true,
      :can_write => false, :is_sticky => false
    })
    assigns[:permission] = @permission
  end

  it "should not raise an error" do
    lambda { render 'permissions/show' }.should_not raise_error
  end

  it "should display the controller" do
    render 'permissions/show'
    response.should have_tag("p", /vampires/) do
      with_tag("b", "Controller:")
    end
  end
end

describe "rendering /permissions/show for a resource permission" do
  before do
    @group = mock_model(Group, :name => 'dudes')
    @pocky = Pocky.new
    @permission = mock_model(Permission, {
      :group => @group, :controller => nil, :resource => @pocky,
      :can_read => true, :can_write => false, :is_sticky => false
    })
    assigns[:permission] = @permission
    @controller.template.stub!(:resource_link).and_return('teh p0cky')
  end

  it "should not raise an error" do
    lambda { render 'permissions/show' }.should_not raise_error
  end

  it "should display the resource" do
    render 'permissions/show'
    response.should have_tag("p", /teh p0cky/) do
      with_tag("b", "Resource:")
    end
  end
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /permissions/edit for a controller permission" do
  before do
    @group = mock_model(Group, :name => "dudes")
    @permission = mock_model(Permission, {
      :group => @group, :controller => "vampires", :can_read => true,
      :can_write => true, :is_sticky => false
    })
    assigns[:permission] = @permission
  end

  it "should not raise an error" do
    lambda { render '/permissions/edit' }.should_not raise_error
  end

  it "should show a resource type of 'Controller'" do
    render '/permissions/edit'
    response.should have_tag("p", /Controller/) do
      with_tag("b", "Resource Type")
    end
  end

  it "should show the controller name" do
    render '/permissions/edit'
    response.should have_tag("p", /vampires/) do
      with_tag("b", "Controller")
    end
  end
end

describe "rendering /permissions/edit for a resource permission" do
  before do
    @group = mock_model(Group, :name => "dudes")
    @pocky = Pocky.new
    @pocky.stub!(:name).and_return("teh p0cky")
    @permission = mock_model(Permission, {
      :group => @group, :resource => @pocky, :resource_type => 'Pocky', :can_read => true,
      :can_write => true, :is_sticky => false, :controller => nil
    })
    assigns[:permission] = @permission
  end

  it "should not raise an error" do
    lambda { render '/permissions/edit' }.should_not raise_error
  end

  it "should show a resource type of 'Pocky'" do
    render '/permissions/edit'
    response.should have_tag("p", /Pocky/) do
      with_tag("b", "Resource Type")
    end
  end

  it "should show the resource name" do
    render '/permissions/edit'
    response.should have_tag("p", /teh p0cky/) do
      with_tag("b", "Resource")
    end
  end
end

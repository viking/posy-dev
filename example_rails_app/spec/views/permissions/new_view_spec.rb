require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /permissions/new" do
  before do
    @groups = Array.new(3) { |i| mock_model(Group, :name => "group-#{i}") }
    @resource_types = %w{Controller Pocky}
    @permission = mock_model(Permission, {
      :group_id => nil, :resource_type => nil, :can_read => nil,
      :can_write => nil, :is_sticky => nil
    })
    assigns[:groups] = @groups
    assigns[:resource_types] = @resource_types
    assigns[:permission] = @permission
  end

  it "should not raise an error" do
    lambda { render '/permissions/new' }.should_not raise_error
  end

  it "should have a groups select box with 3 options" do
    render '/permissions/new'
    response.should have_tag("select#permission_group_id option", :count => 3)
  end

  it "should have a resource type select box with 3 options (including one blank)" do
    render '/permissions/new'
    response.should have_tag("select#permission_resource_type option", :count => 3)
  end

  it "should have 'Controller' selected in the resource type select box when params[:permission][:resource_type] is 'Controller'" do
    # NOTE: using the params accessor doesn't work anymore apparently
    @request.parameters.merge!({ :permission => { :resource_type => 'Controller' } })
    render '/permissions/new'
    response.should have_tag("select#permission_resource_type option[selected]", "Controller")
  end

  it "should have 'Pocky' selected in the resource type select box when params[:permission][:resource_type] is 'Pocky'" do
    @request.parameters.merge!({ :permission => { :resource_type => 'Pocky' } })
    render '/permissions/new'
    response.should have_tag("select#permission_resource_type option[selected]", "Pocky")
  end

  it "should have a resource_id select box that has 4 options (including a blank) when @resources is set" do
    @permission.stub!(:resource_id).and_return(nil)
    resources = [["pocky-1", 1], ["pocky-2", 2], ["pocky-3", 3]]
    assigns[:resources] = resources

    render '/permissions/new'
    response.should have_tag("p#resource_select") do
      with_tag("b", "Resource")
      with_tag("select#permission_resource_id option", :count => 4)
    end
  end

  it "should have a resource_select tag with text when @resources is set and empty" do
    assigns[:resources] = []

    render '/permissions/new'
    response.should have_tag("p#resource_select", /None available/) do
      with_tag("b", "Resource")
    end
  end

  it "should have a resource_select tag with a controller select box that has 4 options (including a blank) when @controllers is set" do
    @permission.stub!(:controller).and_return(nil)
    @controllers = %w{lions tigers bears}
    assigns[:controllers] = @controllers

    render '/permissions/new'
    response.should have_tag("p#resource_select") do
      with_tag("b", "Controller")
      with_tag("select#permission_controller option", :count => 4)
    end
  end

  it "should have a resource_select tag with text when @controllers is set and empty" do
    assigns[:controllers] = []

    render '/permissions/new'
    response.should have_tag("p#resource_select", /None available/) do
      with_tag("b", "Controller")
    end
  end
end

describe "rendering /permissions/new when @group is set" do
  before do
    @group = mock_model(Group, :name => "dudes")
    @resource_types = %w{Controller Pocky}
    @permission = mock_model(Permission, {
      :group_id => nil, :resource_type => nil, :can_read => nil,
      :can_write => nil, :is_sticky => nil
    })
    assigns[:group] = @group
    assigns[:resource_types] = @resource_types
    assigns[:permission] = @permission
  end

  it "should not raise an error" do
    lambda { render '/permissions/new' }.should_not raise_error
  end

  it "should not have a groups select box" do
    render '/permissions/new'
    response.should_not have_tag("select#permission_group_id")
  end
end

describe "rendering /permissions/new.rjs" do
  it "should not raise an error" do
    lambda { render '/permissions/new.rjs' }.should_not raise_error
  end

  it "should clear resource_select" do
    render '/permissions/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do |elements|
      elements.should be_empty
    end
  end
end

describe "rendering /permissions/new.rjs when @resources is set" do
  before(:each) do
    @resources = [["pocky-1", 1], ["pocky-2", 2], ["pocky-3", 3]]
    assigns[:resources] = @resources
  end

  it "should not raise an error" do
    lambda { render '/permissions/new.rjs' }.should_not raise_error
  end

  it "should replace resource_select with a resource_id select box that has 4 options (including a blank)" do
    render '/permissions/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do
      with_tag("b", "Resource")
      with_tag("select#permission_resource_id option", :count => 4)
    end
  end
end

describe "rendering /permissions/new.rjs when @resources is set and empty" do
  before(:each) do
    @resources = []
    assigns[:resources] = @resources
  end

  it "should not raise an error" do
    lambda { render '/permissions/new.rjs' }.should_not raise_error
  end

  it "should replace resource_select with text" do
    render '/permissions/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do
      with_tag("b", "Resource")
      with_tag("p", "None available.") 
    end
  end
end

describe "rendering /permissions/new.rjs when @controllers is set" do
  before(:each) do
    @controllers = %w{lions tigers bears}   # oh my!
    assigns[:controllers] = @controllers
  end

  it "should not raise an error" do
    lambda { render '/permissions/new.rjs' }.should_not raise_error
  end

  it "should replace resource_select with a controller select box that has 4 options (including a blank)" do
    render '/permissions/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do
      with_tag("b", "Controller")
      with_tag("select#permission_controller option", :count => 4)
    end
  end
end

describe "rendering /permissions/new.rjs when @controllers is set and empty" do
  before(:each) do
    @controllers = []
    assigns[:controllers] = @controllers
  end

  it "should not raise an error" do
    lambda { render '/permissions/new.rjs' }.should_not raise_error
  end

  it "should replace resource_select with text" do
    render '/permissions/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do
      with_tag("b", "Controller")
      with_tag("p", "None available.") 
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

module PermissionHelpers
  def create_permission(options)
    Permission.create({
      :can_read => true,
      :can_write => true,
      :is_sticky => false
    }.merge(options))
  end
end

describe Permission do
  include PermissionHelpers
  fixtures :groups, :permissions

  before(:all) do
    Posy.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  it "should create with a resource" do
    permission = create_permission(:group => groups(:weasleys), :resource => Pocky.new)
    permission.should_not be_a_new_record
  end

  it "should create with a controller" do
    permission = create_permission(:group => groups(:weasleys), :controller => "vampires")
    permission.should_not be_a_new_record
  end

  it "should require a valid controller on creation" do
    permission = create_permission(:group => groups(:weasleys), :controller => "dinosaurs")
    permission.errors[:controller].should_not be_nil
  end

  it "should require either a resource or a controller on creation" do
    permission = create_permission(:group => groups(:weasleys))
    permission.errors[:controller].should_not be_nil
    permission.errors[:resource_id].should_not be_nil
  end

  it "should not allow both a resource and a controller on creation" do
    permission = create_permission(:group => groups(:weasleys), :controller => "vampires", :resource => Pocky.new)
    permission.errors[:controller].should_not be_nil
    permission.errors[:resource_id].should_not be_nil
  end

  it "should require a resource_type when there's a resource_id" do
    permission = create_permission(:group => groups(:weasleys), :resource_id => 1)
    permission.errors[:resource_type].should_not be_nil
  end

  it "should require a group on creation" do
    permission = create_permission(:resource => Pocky.new)
    permission.errors[:group_id].should_not be_nil
  end

  it "should not allow duplicate resource permissions" do
    pocky = Pocky.new
    permission1 = create_permission(:group => groups(:weasleys), :resource => pocky)
    permission2 = create_permission(:group => groups(:weasleys), :resource => pocky)
    permission1.should be_valid
    permission2.should_not be_valid
  end

  it "should not allow duplicate controller permissions" do
    permission1 = create_permission(:group => groups(:weasleys), :controller => "vampires")
    permission2 = create_permission(:group => groups(:weasleys), :controller => "vampires")
    permission1.should be_valid
    permission2.should_not be_valid
  end

  describe "when procreating" do
    before(:each) do
      @pocky  = Pocky.new
      @parent = create_permission(:group => groups(:malfoys), :resource => @pocky)
      @child  = create_permission(:parent => @parent, :controller => "vampires")
    end

    it "should assign the child group from its parent" do
      @child.group.should == groups(:malfoys)
    end

    it "should have a valid child" do
      @child.should be_valid
    end

    it "should have a parent with children" do
      @parent.children.should include(@child)
    end
  end

  describe "#can_read?" do
    it "should equal can_read" do
      permission = Permission.new(:can_read => true)
      permission.can_read?.should be_true
      permission[:can_read] = false
      permission.can_read?.should be_false
    end
  end

  describe "#can_write?" do
    it "should equal can_write" do
      permission = Permission.new(:can_write => true)
      permission.can_write?.should be_true
      permission[:can_write] = false
      permission.can_write?.should be_false
    end
  end

  describe "#can_read_and_write?" do
    it "should equal can_read && can_write" do
      permission = Permission.new(:can_write => true, :can_read => false)
      permission.can_read_and_write?.should be_false
      permission[:can_read] = true
      permission.can_read_and_write?.should be_true
    end
  end

  describe "#can_access?" do
    it "should equal can_read when called with 'r'" do
      permission = Permission.new(:can_read => true)
      permission.can_access?('r').should be_true
      permission[:can_read] = false
      permission.can_access?('r').should be_false
    end

    it "should equal can_write when called with 'w'" do
      permission = Permission.new(:can_write => true)
      permission.can_access?('w').should be_true
      permission[:can_write] = false
      permission.can_access?('w').should be_false
    end

    it "should equal can_read && can_write when called with 'rw'" do
      permission = Permission.new(:can_write => true, :can_read => false)
      permission.can_access?('rw').should be_false
      permission[:can_read] = true
      permission.can_access?('rw').should be_true
    end
  end
end

describe "a non-new permission", :shared => true do
  it "should update" do
    @permission.update_attributes(:can_read => false, :can_write => true).should be_true
  end

  it "should belong to a group" do
    @permission.group.should eql(groups(:weasleys))
  end

  it "should belong to a creator" do
    @permission.creator.should eql(users(:admin))
  end

  it "should belong to a updater" do
    @permission.updater.should eql(users(:admin))
  end
end

describe "a non-new resource permission" do
  include PermissionHelpers
  fixtures :users, :groups, :permissions

  before(:each) do
    User.current_user = users(:admin)
    @pocky = Pocky.new
    @permission = create_permission(:group => groups(:weasleys), :resource => @pocky)
  end

  it_should_behave_like "a non-new permission"

  it "should not allow duplicate permissions on update" do
    another_permission = create_permission(:group => groups(:malfoys), :resource => @pocky)
    @permission.update_attributes(:group => groups(:malfoys)).should be_false
  end

  it "should belong to a resource" do
    @permission.resource.should == @pocky
  end
end

describe "a non-new controller permission" do
  include PermissionHelpers
  fixtures :users, :groups, :permissions

  before(:all) do
    Posy.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  before(:each) do
    User.current_user = users(:admin)
    @controller = "vampires" 
    @permission = create_permission(:group => groups(:weasleys), :controller => @controller)
  end

  it_should_behave_like "a non-new permission"

  it "should not allow duplicate permissions on update" do
    another_permission = create_permission(:group => groups(:malfoys), :controller => @controller)
    @permission.update_attributes(:group => groups(:malfoys)).should be_false
  end
end

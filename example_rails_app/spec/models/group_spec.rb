require File.dirname(__FILE__) + '/../spec_helper'

module GroupHelpers
  def create_group(options = {})
    Group.create({
      :name => 'foo', 
      :description => 'the foo group', 
      :permanent => false
    }.merge(options))
  end
end

describe Group do
  include GroupHelpers
  fixtures :groups, :users

  it "should create a new group" do
    group = create_group
    group.should_not be_a_new_record
  end

  it "should require name on creation" do
    group = create_group(:name => nil)
    group.errors[:name].should_not be_nil
  end

  it "should require a unique name on creation" do
    group1 = create_group
    group2 = create_group
    group1.errors[:name].should be_nil
    group2.errors[:name].should_not be_nil
  end

  it "should belong to creator" do
    User.current_user = users(:admin)
    group = create_group
    group.creator.should eql(users(:admin))
  end
end

describe "an existing group", :shared => true do
  it "should belong to creator" do
    @group.creator.should eql(users(:admin))
  end
end

describe "a non-permanent group" do
  include GroupHelpers
  fixtures :groups, :users

  before(:each) do
    User.current_user = users(:admin)
    @group = create_group
  end

  it_should_behave_like "an existing group"

  it "should update" do
    @group.update_attribute(:description, "1337 h4x0rz").should be_true
  end

  it "should belong to updater after updating" do
    User.current_user = users(:admin)
    @group.update_attribute(:description, "1337 h4x0rz")
    @group.updater.should eql(users(:admin))
  end

  it "should destroy" do
    old_count = Group.count
    @group.destroy
    Group.count.should < old_count
  end
end

describe "a permanent group" do
  include GroupHelpers
  fixtures :groups, :users

  before(:each) do
    User.current_user = users(:admin)
    @group = create_group(:permanent => true)
  end

  it_should_behave_like "an existing group"

  it "should raise an error when trying to update" do
    lambda do
      @group.update_attribute(:description, "1337 h4x0rz").should be_true
    end.should raise_error
  end

  it "should raise an error when trying to destroy" do
    lambda do
      @group.destroy
    end.should raise_error
  end
end

describe Group, "with two users" do
  include GroupHelpers
  fixtures :groups, :users

  before(:each) do
    User.current_user = users(:admin)
    @group = create_group
    @group.users << users(:fred)
    @group.users << users(:george)
  end

  it_should_behave_like "an existing group"

  it "should include the first user" do
    @group.should include(users(:fred))
  end

  it "should include the first user's id" do
    @group.should include(users(:fred).id)
  end

  it "should not include a user not in the group" do
    @group.should_not include(users(:draco))
  end

  it "should have two memberships" do
    @group.should have(2).memberships
  end

  it "should have two users" do
    @group.should have(2).users
  end


  it "should have excluded users" do
    @group.should have_at_least(1).users_not_in
  end
end

describe Group, "with one permission" do
  include GroupHelpers
  fixtures :groups, :users, :permissions

  before(:each) do
    User.current_user = users(:admin)
    @group = create_group
    @perm = @group.permissions.create(:resource => users(:admin))
  end

  it_should_behave_like "an existing group"

  it "should have that permission" do
    @group.permissions[0].should eql(@perm)
  end
end

describe Group, "with some permissions" do
  include GroupHelpers
  fixtures :groups, :users, :permissions

  before(:each) do
    Posy.stub!(:controllers).and_return(%w{pockies})
    User.current_user = users(:admin)
    @group  = create_group
    @pocky1 = Pocky.new(1)
    @pocky2 = Pocky.new(2)
    @perm1  = @group.permissions.create(:resource => @pocky1)
    @perm2  = @group.permissions.create(:controller => "pockies")
    @perm3  = @group.permissions.create(:resource => @pocky2)
  end

  it_should_behave_like "an existing group"

  it "should get permissions.for(@pocky1)" do
    @group.permissions.for(@pocky1).should == @perm1 
  end

  it "should get permissions.for('pockies')" do
    @group.permissions.for('pockies').should == @perm2
  end

  it "should get permissions.for(Pocky)" do
    @group.permissions.for(Pocky).should == [@perm1, @perm3]
  end
end

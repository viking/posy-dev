require File.dirname(__FILE__) + '/../spec_helper'

module UserHelpers
  def create_user(options = {})
    User.create({
      :login => "alucard",
      :email => "vampires@rock.com",
      :password => "immortal",
      :password_confirmation => "immortal"
    }.update(options))
  end
end

describe User do
  include UserHelpers
  fixtures :users

  it "should create a new user" do
    user = create_user
    user.should_not be_a_new_record
  end

  it "should require a login on creation" do
    user = create_user(:login => nil)
    user.errors[:login].should_not be_nil
  end

  it "should require a password on creation" do
    user = create_user(:password => nil)
    user.errors[:password].should_not be_nil
  end

  it "should require a password confirmation on creation" do
    user = create_user(:password_confirmation => nil)
    user.errors[:password_confirmation].should_not be_nil
  end

  it "should require an email on creation" do
    user = create_user(:email => nil)
    user.errors[:email].should_not be_nil
  end

  it "should authenticate a user with a correct password" do
    User.authenticate('admin', 'test').should == users(:admin)
  end
end

describe "a non-new user" do
  include UserHelpers
  fixtures :users

  before(:each) do
    User.current_user = users(:admin)
    @user = create_user
  end

  it "should be valid" do
    @user.should be_valid
  end

  it "should reset its password" do
    @user.update_attributes(:password => "blood", :password_confirmation => "blood")
    User.authenticate('alucard', 'blood').should == @user
  end

  it "should not rehash its password if not changing it" do
    @user.update_attribute(:login, 'arucard')
    User.authenticate('arucard', 'immortal').should == @user
  end

  it "should get groups not in" do
    @user.should have_at_least(1).groups_not_in
  end

  it "should belong to a creator" do
    @user.creator.should == users(:admin)
  end

  it "should belong to an updater" do
    @user.updater.should == users(:admin)
  end

  it "should not be an admin" do
    @user.should_not be_an_admin
  end
end

describe User, "that belongs in a group with one permission" do
  include UserHelpers
  fixtures :users, :groups, :permissions, :memberships

  before(:all) do
    Posy.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  before(:each) do
    User.current_user = users(:admin)

    @user = create_user
    @group = Group.create(:name => 'vampires')
    @user.groups << @group
    @perm = @group.permissions.create(:controller => 'vampires', :can_read => true, :can_write => true)
  end

  it "should have one membership" do
    @user.should have(1).memberships
  end

  it "should have one group" do
    @user.should have(1).groups
  end

  it "should have one permission" do
    @user.should have(1).permissions
  end

  it "should delete its memberships on destroy" do
    @user.destroy
    Membership.find_all_by_user_id(@user.id).should be_empty
  end
end

describe User, "that belongs in a group with many permissions" do
  include UserHelpers
  fixtures :users, :groups, :permissions, :memberships

  before(:all) do
    Posy.send(:class_variable_set, "@@configuration", { 'controllers' => %w{vampires werewolves unicorns} })  # </hax>
  end

  before(:each) do
    User.current_user = users(:admin)

    @user = create_user
    group = Group.create(:name => 'vampires')
    group.permissions.create(:controller => 'vampires',   :can_read => true, :can_write => true)
    group.permissions.create(:controller => 'werewolves', :can_read => true, :can_write => false)
    group.permissions.create(:controller => 'unicorns',   :can_read => false, :can_write => true)

    @pocky = Array.new(3) { |i| Pocky.new(i+1) }
    group.permissions.create(:resource => @pocky[0], :can_read => true, :can_write => true)
    group.permissions.create(:resource => @pocky[1], :can_read => true, :can_write => false)
    group.permissions.create(:resource => @pocky[2], :can_read => false, :can_write => true)
    @user.groups << group
  end

  it "should have six permissions" do
    @user.should have(6).permissions
  end

  it "should have three controller permissions" do
    @user.should have(3).controller_permissions
  end

  it "should have three resource permissions" do
    @user.should have(3).resource_permissions
  end

  # can't have too many tests =)
  it "should have read and write access to the vampires controller" do
    @user.should have_access_to("vampires", "b")
    @user.should have_read_and_write_access_to("vampires")
  end

  it "should have read access to the werewolves controller" do
    @user.should have_access_to("werewolves", "r")
    @user.should have_read_access_to("werewolves")
  end

  it "should not have write access to the werewolves controller" do
    @user.should_not have_access_to("werewolves", "w")
    @user.should_not have_write_access_to("werewolves")
  end

  it "should not have read and write access to the werewolves controller" do
    @user.should_not have_access_to("werewolves", "b")
    @user.should_not have_read_and_write_access_to("werewolves")
  end

  it "should have write access to the unicorns controller" do
    @user.should have_access_to("unicorns", "w")
    @user.should have_write_access_to("unicorns")
  end

  it "should not have read access to the unicorns controller" do
    @user.should_not have_access_to("unicorns", "r")
    @user.should_not have_read_access_to("unicorns")
  end

  it "should not have read and write access to the unicorns controller" do
    @user.should_not have_access_to("unicorns", "b")
    @user.should_not have_read_and_write_access_to("unicorns")
  end

  it "should have read and write access to pocky #1" do
    @user.should have_access_to(@pocky[0], "b")
    @user.should have_read_and_write_access_to(@pocky[0])
  end

  it "should have read access to pocky #2" do
    @user.should have_access_to(@pocky[1], "r")
    @user.should have_read_access_to(@pocky[1])
  end

  it "should not have write access to pocky #2" do
    @user.should_not have_access_to(@pocky[1], "w")
    @user.should_not have_write_access_to(@pocky[1])
  end

  it "should not have read and write access to pocky #2" do
    @user.should_not have_access_to(@pocky[1], "b")
    @user.should_not have_read_and_write_access_to(@pocky[1])
  end

  it "should have write access to pocky #3" do
    @user.should have_access_to(@pocky[2], "w")
    @user.should have_write_access_to(@pocky[2])
  end

  it "should not have read access to pocky #3" do
    @user.should_not have_access_to(@pocky[2], "r")
    @user.should_not have_read_access_to(@pocky[2])
  end

  it "should not have read and write access to pocky #3" do
    @user.should_not have_access_to(@pocky[2], "b")
    @user.should_not have_read_and_write_access_to(@pocky[2])
  end
end

describe User, "in the admin group" do
  include UserHelpers
  fixtures :users, :groups, :permissions, :memberships

  before(:each) do
    User.current_user = users(:admin)
    @user = create_user
    @user.memberships.create(:group => groups(:admin))
  end

  it "should be an admin" do
    @user.should be_an_admin
  end
end

class ::TestMonkey < ActiveRecord::Base
end

describe User, "in a group with several individual resource permissions" do
  include UserHelpers
  fixtures :users, :groups, :permissions, :memberships

  before(:all) do
    ActiveRecord::Base.connection.create_table(:test_monkeys, :force => true) do |t|
      t.column :name, :string
    end
  end

  before(:each) do
    @user  = create_user
    @group = Group.create(:name => 'jungle') 
    @user.memberships.create(:group => @group)

    @monkeys = Array.new(5) { |i| TestMonkey.create(:name => "Monkey #{i+1}") }
  end

  it "should have 3 readable resources" do
    @monkeys[0..2].each { |m| @group.permissions.create(:resource => m, :can_read => true) }
    resources = @user.resources(TestMonkey, :r)
    resources.collect { |r| r.name }.should == @monkeys[0..2].collect { |m| m.name }
  end

  it "should have 3 writeable resources" do
    @monkeys[0..2].each { |m| @group.permissions.create(:resource => m, :can_write => true) }
    @user.resources(TestMonkey, :w).length.should == 3
  end

  it "should have 3 read-and-writeable resources" do
    @monkeys[0..2].each { |m| @group.permissions.create(:resource => m, :can_read => true, :can_write => true) }
    @user.resources(TestMonkey, :rw).length.should == 3
    @user.resources(TestMonkey, :wr).length.should == 3
    @user.resources(TestMonkey, :b).length.should == 3
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:test_monkeys)
  end
end

describe User, "in three groups, each with one resource permission" do
  include UserHelpers
  fixtures :users, :groups, :permissions, :memberships

  before(:all) do
    ActiveRecord::Base.connection.create_table(:test_monkeys, :force => true) do |t|
      t.column :name, :string
    end
  end

  before(:each) do
    @user    = create_user
    @monkeys = Array.new(5) { |i| TestMonkey.create(:name => "Monkey #{i+1}") }
    @groups  = Array.new(3) do |i|
      group = Group.create(:name => "test group #{i}")
      @user.memberships.create(:group => group)
      group
    end
  end

  it "should have 3 readable resources" do
    @groups.each_with_index do |g, i|
      perm = g.permissions.create(:resource => @monkeys[i], :can_read => true)
    end
    @user.resources(TestMonkey, :r).length.should == 3
  end

  it "should have 3 writable resources" do
    @groups.each_with_index do |g, i|
      perm = g.permissions.create(:resource => @monkeys[i], :can_write => true)
    end
    @user.resources(TestMonkey, :w).length.should == 3
  end

  it "should have 3 read-and-writable resources" do
    @groups.each_with_index do |g, i|
      perm = g.permissions.create(:resource => @monkeys[i], :can_read => true, :can_write => true)
    end
    @user.resources(TestMonkey, :rw).length.should == 3
    @user.resources(TestMonkey, :wr).length.should == 3
    @user.resources(TestMonkey, :b).length.should == 3
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:test_monkeys)
  end
end

describe User, "with explicit access to some resources and a default controller permission" do
  include UserHelpers
  fixtures :users, :groups, :permissions, :memberships

  before(:all) do
    ActiveRecord::Base.connection.create_table(:test_monkeys, :force => true) do |t|
      t.column :name, :string
    end
  end

  before(:each) do
    @user    = create_user
    @monkeys = Array.new(5) { |i| TestMonkey.create(:name => "Monkey #{i+1}") }
    @groups  = Array.new(3) do |i|
      group = Group.create(:name => "test group #{i}")
      @user.memberships.create(:group => group)
      group
    end
    Posy.stub!(:controllers).and_return(%w{test_monkeys})
  end

  it "should have 5 readable resources when controller permission also has read access" do
    (0..2).each do |i|
      perm = @groups[i].permissions.create(:resource => @monkeys[i], :can_read => true)
    end
    @groups[2].permissions.create(:controller => 'test_monkeys', :can_read => true)
    @user.resources(TestMonkey, :r).length.should == 5
  end

  it "should have 3 writeable resources when controller permission does not have write access" do
    (0..2).each do |i|
      perm = @groups[i].permissions.create(:resource => @monkeys[i], :can_write => true)
    end
    @groups[2].permissions.create(:controller => 'test_monkeys', :can_write => false)
    @user.resources(TestMonkey, :w).length.should == 3
  end

  it "should have 4 readable resources when controller permission has read access and one resource is explicity denied" do
    (0..2).each do |i|
      perm = @groups[i].permissions.create(:resource => @monkeys[i], :can_read => true)
    end
    @groups[0].permissions.create(:resource => @monkeys[3], :can_read => false)
    @groups[2].permissions.create(:controller => 'test_monkeys', :can_read => true)
    @user.resources(TestMonkey, :r, true).length.should == 4
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:test_monkeys)
  end
end

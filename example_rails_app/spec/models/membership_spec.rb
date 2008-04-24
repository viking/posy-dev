require File.dirname(__FILE__) + '/../spec_helper'

module MembershipHelpers
  def create_membership(user, group)
    Membership.create({
      :user  => user,
      :group => group
    })
  end
end

describe Membership do
  include MembershipHelpers
  fixtures :users, :groups, :memberships, :permissions

  before(:all) do
    Posy.send(:class_variable_set, "@@configuration", { 'controllers' => %w{vampires werewolves} })  # </hax>
  end

  it "should create" do
    membership = create_membership(users(:fred), groups(:weasleys))
    membership.should_not be_a_new_record
  end

  it "should require group on creation" do
    membership = create_membership(users(:fred), nil)
    membership.errors[:group_id].should_not be_nil
  end

  it "should require user on creation" do
    membership = create_membership(nil, groups(:weasleys))
    membership.errors[:user_id].should_not be_nil
  end

  it "should not allow duplicate memberships" do
    membership1 = create_membership(users(:fred), groups(:weasleys))
    membership2 = create_membership(users(:fred), groups(:weasleys))
    membership1.should be_valid
    membership2.should_not be_valid
  end

  it "should not allow users to join groups with overlapping permissions" do
    group1 = Group.create(:name => "uber")
    group2 = Group.create(:name => "leet")
    group1.permissions.create(:controller => "vampires", :can_read  => true)
    group2.permissions.create(:controller => "vampires", :can_write => true)

    membership1 = create_membership(users(:fred), group1)
    membership2 = create_membership(users(:fred), group2)
    membership1.should be_valid
    membership2.should_not be_valid
  end
end

describe "a non-new membership" do
  include MembershipHelpers
  fixtures :users, :groups, :memberships, :permissions

  before(:each) do
    User.current_user = users(:admin)
    @membership = create_membership(users(:george), groups(:weasleys))
  end

  it "should belong to a user" do
    @membership.user.should eql(users(:george))
  end

  it "should belong to a group" do
    @membership.group.should eql(groups(:weasleys))
  end

  it "should belong to a creator" do
    @membership.creator.should eql(users(:admin))
  end

  it "should belong to an updater" do
    @membership.updater.should eql(users(:admin))
  end
end

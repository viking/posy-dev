class Membership < ActiveRecord::Base
  validates_presence_of   :user_id, :group_id
  validates_uniqueness_of :group_id, :scope => :user_id

  # users can only belong in one group per permission
  # i.e. billy can't be in one group with read-only permissions on
  #      project 'foo' and be in another group with read/write
  #      permissions on the same project
  validate :unique_permissions

  belongs_to :group
  belongs_to :user
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"

  protected
    def unique_permissions
      return  unless user_id and group_id

      # get a list of all resources for the specified group
      resources = group.permissions.collect do |perm|
        perm.resource ? "#{perm.resource_type}_#{perm.resource_id}" : perm.controller
      end

      # for all the groups this user belongs in, see if there are any duplicate resources
      duplicates = Hash.new { |h,k| h[k] = [] }
      user.groups.find(:all, :conditions => ['group_id != ?', group_id]).each do |g|
        g.permissions.each do |perm|
          tmp = perm.resource ? "#{perm.resource_type}_#{perm.resource_id}" : perm.controller
          duplicates[g.name] << tmp   if resources.include?(tmp)
        end
      end

      if duplicates.keys.length > 0
        errors.add(:group_id, "cannot be used because it has overlapping permissions with the user's current groups")
      end
    end
end

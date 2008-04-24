class Group < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  has_many :permissions, :dependent => :destroy do
    def for(resource)
      case resource
      when String
        find_by_controller(resource)
      when Class
        find :all, 
          :conditions => ['resource_type = ?', resource.to_s]
      else
        find :first, 
          :conditions => ['resource_id = ? AND resource_type = ?', resource.id, resource.class.to_s]
      end
    end
  end
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"

  # ensure the group isn't permanent
  def before_update
    raise "can't update permanent group"   if self['permanent']
  end

  # ensure the group isn't permanent
  def before_destroy
    raise "can't destroy permanent group"   if self['permanent']
  end
  
  def include?(user)
    unless user.is_a?(User) or user.is_a?(Fixnum)
      raise TypeError, "not a User or Fixnum"
    end

    user_id = user.is_a?(User) ? user['id'] : user
    users.count(:conditions => ["user_id = ?", user_id]) > 0
  end

  def users_not_in
    exclude_list = users.collect { |u| "id != #{quote_value(u)}" }
    exclude_sql  = exclude_list.empty? ? nil : exclude_list.join(" AND ")
    User.find(:all, :conditions => exclude_sql)
  end
end

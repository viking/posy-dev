require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  # needed for the userstamp plugin
  cattr_accessor :current_user

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"

  # TODO: destroying users should probably be disabled unless the user was created
  #       by mistake; user id's will probably be in lots of tables (like audit trails)
  #       that need to be maintained even if a user's access to a resource is terminated

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find(:first, :conditions => ['login = ?', login], :include => :groups) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def self.admin?(user)
    @@admin_group ||= Group.find_by_name('admin')
    @@admin_group.include?(user)
  end
    
  def admin?
    self.class.admin?(self)
  end

  def permissions(force_reload = false)
    unless @permissions and !force_reload
      g = groups.find(:all, :include => :permissions)
      @permissions = Permission.find_by_sql([<<-end_of_sql, self.id])
        SELECT p.*  FROM users u 
                    JOIN memberships m ON u.id = m.user_id 
                    JOIN groups g ON g.id = m.group_id
                    JOIN permissions p ON g.id = p.group_id
        WHERE u.id = ?
      end_of_sql
    end
    @permissions
  end

  def controller_permissions(force_reload = false)
    unless @controller_permissions and !force_reload
      @controller_permissions = Permission.find_by_sql([<<-end_of_sql, self.id])
        SELECT p.*  FROM users u 
                    JOIN memberships m ON u.id = m.user_id 
                    JOIN groups g ON g.id = m.group_id
                    JOIN permissions p ON g.id = p.group_id
        WHERE u.id = ? AND p.controller IS NOT NULL
      end_of_sql
    end
    @controller_permissions
  end

  def resource_permissions(force_reload = false)
    unless @resource_permissions and !force_reload
      @resource_permissions = Permission.find_by_sql([<<-end_of_sql, self.id])
        SELECT p.*  FROM users u 
                    JOIN memberships m ON u.id = m.user_id 
                    JOIN groups g ON g.id = m.group_id
                    JOIN permissions p ON g.id = p.group_id
        WHERE u.id = ? AND p.resource_id IS NOT NULL
      end_of_sql
    end
    @resource_permissions
  end

  # Return an array of all resources that the user has the specified access to.  This
  # looks at the appropriate controller permission (if it exists) to get default permissions.
  #
  # parameters:
  #   klass       - a Class
  #   access_mode - 'r', 'w', 'rw', or 'b'  (b == rw)
  def resources(klass, access_mode, force_reload = false)
    access_requirement, access_values = case access_mode.to_s
      when 'r'
        ["p.can_read = ?", [true]]
      when 'w'
        ["p.can_write = ?", [true]]
      when 'rw', 'wr', 'b'
        ["p.can_read = ? AND p.can_write = ?", [true, true]]
      else
        raise "bad access_mode"
    end
    
    # FIXME: don't assume the controller name is klass.table_name 
    controller_name = klass.table_name
    table_name      = klass.table_name
    group_ids_sql   = "(" + memberships.collect { |m| m.group_id }.join(", ") + ")"

    if self.can_access?(controller_name, access_mode)
      # this means the user has default access to the whole lot of #{klass} resources
      klass.find_by_sql([<<-end_of_sql, klass.to_s] + access_values)
        SELECT  k.* FROM #{table_name} k
                    LEFT JOIN permissions p ON k.id = p.resource_id AND p.resource_type = ?
        WHERE   (p.group_id IN #{group_ids_sql} AND #{access_requirement}) OR p.id IS NULL
      end_of_sql

      # same thing using find
#      klass.find :all, 
#        :joins => "LEFT JOIN permissions perm ON perm.resource_id = #{table_name}.id AND perm.resource_type = '#{klass.to_s}'",
#        :conditions => ["(perm.group_id IN (#{group_ids.join(", ")}) AND #{access_requirement}) OR perm.id IS NULL"] + access_values
    else
      klass.find_by_sql([<<-end_of_sql, klass.to_s] + access_values)
        SELECT  k.* FROM #{table_name} k
                    JOIN permissions p ON k.id = p.resource_id AND p.resource_type = ? 
        WHERE   p.group_id IN #{group_ids_sql} AND #{access_requirement}
      end_of_sql
    end
  end

  # returns true or false depending on whether or not the user can
  # access =thing= in the manner specified by =type= ('r', 'w', or 'rw')
  #
  # parameters:
  #   thing       - a String (for controller) or ActiveRecord::Base descendant
  #   access_mode - 'r', 'w', 'rw', or 'b'  (b == rw)
  def can_access?(thing, access_mode)
    case thing
    when String, Symbol
      # controller
      # NOTE: no effort is made here to make sure the #{thing} controller exists
      perm = permissions.detect { |p| p.controller == thing.to_s }
    when ActiveRecord::Base
      perm = permissions.detect { |p| p.resource == thing }
    else
      raise "bad thing"
    end

    case access_mode.to_s
    when 'r'
      admin? || (perm && perm.can_read?)
    when 'w'
      admin? || (perm && perm.can_write?)
    when 'rw', 'wr', 'b'
      admin? || (perm && perm.can_read? && perm.can_write?)
    else
      raise "bad access_mode"
    end
  end
  alias :has_access_to? :can_access?

  def can_read?(thing)
    can_access?(thing, 'r')
  end
  alias :has_read_access_to? :can_read?

  def can_write?(thing)
    can_access?(thing, 'w')
  end
  alias :has_write_access_to? :can_write?

  def can_read_and_write?(thing)
    can_access?(thing, 'rw')
  end
  alias :has_read_and_write_access_to? :can_read_and_write?

  def groups_not_in
    exclude_list = groups.collect { |g| "id != #{quote_value(g)}" }
    exclude_sql  = exclude_list.empty? ? nil : exclude_list.join(" AND ")
    Group.find(:all, :conditions => exclude_sql)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end

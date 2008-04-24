class Permission < ActiveRecord::Base
  validates_presence_of :group_id

  # only resource_id or controller can exist, but at least one of them must exist
  validates_each :resource_id do |r, a, v|
    if v.nil?
      r.errors.add(a, 'must exist if no controller') if r.controller.nil? or r.controller.empty?

    elsif !r.controller.nil? and !r.controller.empty?
      r.errors.add(a, 'cannot exist if controller exists')

    # resource_type must exist if resource_id exists
    elsif r.resource_type.nil?
      r.errors.add(:resource_type, 'cannot be blank')

    # cannot have more than one group/resource combo
    elsif r.new_record? and r.group_id and Permission.count(:conditions => ["group_id = ? AND resource_type = ? and resource_id = ?", r.group_id, r.resource_type, v]) > 0
      r.errors.add(a, "already has permissions for specified group")

    # don't check existing permission if updating
    elsif r.group_id and Permission.count(:conditions => ["group_id = ? AND resource_type = ? AND resource_id = ? AND id != ?", r.group_id, r.resource_type, v, r.id]) > 0
      r.errors.add(a, "already has permissions for specified group")
    end
  end

  validates_each :controller do |r, a, v|
    if v.nil? or v.empty?
      r.errors.add(a, 'must exist if no resource_id') if r.resource_id.nil?

    elsif !r.resource_id.nil?
      r.errors.add(a, 'cannot exist if resource_id exists')

    # make sure this controller exists
    elsif !Posy.controllers.include?(v)
      r.errors.add(a, 'is not valid')

    # cannot have more than one group/controller combo
    elsif r.new_record? and r.group_id and Permission.count(:conditions => ["group_id = ? AND controller = ?", r.group_id, v]) > 0
      r.errors.add(a, "already has permissions for specified group")

    elsif r.group_id and Permission.count(:conditions => ["group_id = ? AND controller = ? AND id != ?", r.group_id, v, r.id]) > 0
      r.errors.add(a, "already has permissions for specified group")
    end
  end

  belongs_to :group
  belongs_to :resource, :polymorphic => true
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"

  def can_read?
    self['can_read']
  end
  
  def can_write?
    self['can_write']
  end

  def can_read_and_write?
    self['can_read'] && self['can_write']
  end

  def can_access?(access_mode)
    case access_mode.to_s
    when 'r'
      self['can_read']
    when 'w'
      self['can_write']
    when 'rw', 'wr', 'b'
      self['can_read'] && self['can_write']
    else
      raise "bad access mode"
    end 
  end
end

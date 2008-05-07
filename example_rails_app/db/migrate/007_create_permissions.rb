class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :group_id, :integer
      t.column :controller, :string
      t.column :resource_id, :integer
      t.column :resource_type, :string
      t.column :can_read, :boolean
      t.column :can_write, :boolean
      t.column :is_sticky, :boolean
      t.column :parent_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :integer
      t.column :updated_by, :integer
    end

    User.find_by_login('admin').memberships.create(:group => Group.find_by_name('admin'))
  end

  def self.down
    drop_table :permissions
  end
end

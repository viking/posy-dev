class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.column :group_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :integer
      t.column :updated_by, :integer
    end
  end

  def self.down
    drop_table :memberships
  end
end

class CreateGroups < ActiveRecord::Migration
  class Group < ActiveRecord::Base
  end
  
  def self.up
    create_table :groups do |t|
      t.column :name,        :string
      t.column :description, :string
      t.column :permanent,   :boolean, :default => false
      t.column :created_at,  :datetime
      t.column :updated_at,  :datetime
      t.column :created_by,  :integer
      t.column :updated_by,  :integer
    end
    g = Group.create(:name => 'admin', :description => 'administration group', :permanent => true)
  end

  def self.down
    drop_table :groups
  end
end

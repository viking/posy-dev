class CreateCats < ActiveRecord::Migration
  def self.up
    create_table :cats do |t|
      t.column :name, :string
      t.column :person_id, :integer
      t.column :created_by, :integer
      t.column :updated_by, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :cats
  end
end

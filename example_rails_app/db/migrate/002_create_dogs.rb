class CreateDogs < ActiveRecord::Migration
  def self.up
    create_table :dogs do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :dogs
  end
end

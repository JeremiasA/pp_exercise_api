class CreateUsers < ActiveRecord::Migration
  def self.up
    return if table_exists? :users

    create_table :users do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password_digest
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def self.down
    return unless table_exists? :users

    drop_table :users
  end
end

class CreateClients < ActiveRecord::Migration
  def self.up
    return if table_exists? :clients

    create_table :clients do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :doc_number, null: false
      t.string :email, null: false, email: true
      t.string :phone, null: false
      t.string :zip_code, null: false
      t.string :address, null: false

      t.references :user, foreing_key: true, null: false

      t.timestamps
    end

    add_index :clients, :email, unique: true
  end

  def self.down
    return unless table_exists? :clients

    drop_table :clients
  end
end

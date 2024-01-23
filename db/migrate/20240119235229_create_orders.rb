class CreateOrders < ActiveRecord::Migration
  def self.up
    return if table_exists? :orders

    create_table :orders do |t|
      t.string :code, null: false
      t.string :status, null: false
      t.string :payment_method, null: false
      t.string :shipping_method, null: false
      t.float :shipping_price, null: false
      t.float :total_price

      t.references :client, foreing_key: true, null: false
      t.references :product, foreing_key: true, null: false

      t.timestamps
    end

    add_index :orders, :product_id
    add_index :orders, :code, unique: true
  end

  def self.down
    return unless table_exists? :orders

    drop_table :orders
  end
end

class CreateProducts < ActiveRecord::Migration
  def self.up
    return if table_exists? :products

    create_table :products do |t|
      t.string :title
      t.string :code
      t.string :description
      t.float :sell_price
      t.float :cost
      t.float :weight
      t.float :width
      t.float :length
      t.float :height

      t.references :user, foreing_key: true, null: false

      t.timestamps
    end

    add_index :products, :code, unique: true
  end

  def self.down
    return unless table_exists? :products

    drop_table :products
  end
end

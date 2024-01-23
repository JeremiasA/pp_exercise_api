class CreateCategoryItems < ActiveRecord::Migration
  def self.up
    create_table :category_items do |t|
      t.references :category, foreing_key: true, null: false
      t.references :product, foreing_key: true, null: false

      t.timestamps
    end

    add_index :category_items, [:product_id, :category_id], name: 'index_items_on_product_and_category', unique: true
  end

  def self.down
    drop_table :category_items
  end
end

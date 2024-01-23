class CreateCategories < ActiveRecord::Migration
  def self.up
    unless table_exists? :categories
      create_table :categories do |t|
        t.string :code, null: false
        t.string :description, null: false, limit: 50

        t.references :user, foreing_key: true, null: false

        t.timestamps
      end
    end
  end

  def self.down
    drop_table :categories if table_exists? :categories
  end
end

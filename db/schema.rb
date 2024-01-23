# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(version: 20_240_120_192_506) do
  create_table 'categories', force: true do |t|
    t.string   'code',                      null: false
    t.string   'description', limit: 50, null: false
    t.integer  'user_id', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'category_items', force: true do |t|
    t.integer  'category_id', null: false
    t.integer  'product_id',  null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'clients', force: true do |t|
    t.string   'name',       null: false
    t.string   'last_name',  null: false
    t.string   'doc_number', null: false
    t.string   'email',      null: false
    t.string   'phone',      null: false
    t.string   'zip_code',   null: false
    t.string   'address',    null: false
    t.integer  'user_id',    null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'orders', force: true do |t|
    t.string   'code',            null: false
    t.string   'status',          null: false
    t.string   'payment_method',  null: false
    t.string   'shipping_method', null: false
    t.float    'shipping_price',  null: false
    t.float    'total_price'
    t.integer  'client_id',       null: false
    t.integer  'product_id',      null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'products', force: true do |t|
    t.string   'title'
    t.string   'code'
    t.string   'description'
    t.float    'sell_price'
    t.float    'cost'
    t.float    'weight'
    t.float    'width'
    t.float    'length'
    t.float    'height'
    t.integer  'user_id', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'users', force: true do |t|
    t.string   'name',                              null: false
    t.string   'last_name',                         null: false
    t.string   'email',                             null: false
    t.string   'password_digest'
    t.boolean  'active', default: true, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end
end

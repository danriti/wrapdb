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

ActiveRecord::Schema.define(:version => 20121118001201) do

  create_table "dictionaries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "endpoints", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.integer  "dictionary_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "endpoints", ["dictionary_id"], :name => "index_endpoints_on_dictionary_id"
  add_index "endpoints", ["project_id"], :name => "index_endpoints_on_project_id"

  create_table "errays", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "keytype"
    t.string   "value"
    t.integer  "dictionary_id"
    t.integer  "erray_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "blueprint_id"
  end

  add_index "items", ["blueprint_id"], :name => "index_items_on_blueprint_id"
  add_index "items", ["dictionary_id"], :name => "index_items_on_dictionary_id"
  add_index "items", ["erray_id"], :name => "index_items_on_erray_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "tuples", :force => true do |t|
    t.string   "key"
    t.integer  "dictionary_id"
    t.integer  "item_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "tuples", ["dictionary_id"], :name => "index_tuples_on_dictionary_id"
  add_index "tuples", ["item_id"], :name => "index_tuples_on_item_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

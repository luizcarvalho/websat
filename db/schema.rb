# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

  create_table "aliases", :force => true do |t|
    t.string   "address",                      :null => false
    t.text     "goto",                         :null => false
    t.integer  "dominio_id",                   :null => false
    t.boolean  "active",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dominios", :force => true do |t|
    t.string   "domain",                               :null => false
    t.text     "description"
    t.integer  "maxaliases",   :default => 250,        :null => false
    t.integer  "maxmailboxes", :default => 250,        :null => false
    t.integer  "maxquota",     :default => 10240000,   :null => false
    t.string   "transport",    :default => "maildrop", :null => false
    t.boolean  "backupmx",     :default => false,      :null => false
    t.boolean  "active",       :default => true,       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupo_permissoes", :force => true do |t|
    t.integer  "permissao_id"
    t.integer  "grupo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupo_usuarios", :force => true do |t|
    t.integer  "grupo_id",   :null => false
    t.integer  "usuario_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupos", :force => true do |t|
    t.string   "nome",       :limit => 100, :null => false
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailboxes", :force => true do |t|
    t.integer  "usuario_id",                          :null => false
    t.string   "maildir"
    t.string   "homedir",    :default => "/postfix/", :null => false
    t.integer  "quota",      :default => 25000,       :null => false
    t.integer  "dominio_id",                          :null => false
    t.boolean  "active",     :default => true,        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.string   "label",      :limit => 60,  :null => false
    t.string   "url",        :limit => 100, :null => false
    t.integer  "pai"
    t.integer  "ordem",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissoes", :force => true do |t|
    t.string   "nome",       :limit => 100, :null => false
    t.string   "recurso",    :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "nome",                      :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "active",                                   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

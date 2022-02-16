class CreateDominios < ActiveRecord::Migration
  def self.up
    create_table :dominios, :force => true do |t|
      t.string :domain, :null=> false
      t.text :description
      t.integer :maxaliases, :null=> false, :default=> 250
      t.integer :maxmailboxes, :null=> false, :default=> 250
      t.integer :maxquota, :null=> false, :default=> 10240000
      t.string :transport, :null=> false, :default=> 'maildrop'
      t.boolean :backupmx, :null=> false, :default=> false
      t.boolean :active, :null=> false, :default=> true

      t.timestamps
    end
  end

  def self.down
    drop_table :dominios
  end
end

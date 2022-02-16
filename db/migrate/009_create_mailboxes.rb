class CreateMailboxes < ActiveRecord::Migration
  def self.up
    create_table :mailboxes, :force => true do |t|
      t.belongs_to :usuario, :null=> false
      t.string :maildir
      t.string :homedir, :null=> false, :default=> '/postfix/'
      t.integer :quota, :null=> false, :default=> 25000
      t.belongs_to :dominio, :null=> false
      t.boolean :active, :null=> false, :default=> true

      t.timestamps
    end
  end

  def self.down
    drop_table :mailboxes
  end
end

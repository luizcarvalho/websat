class CreateAliases < ActiveRecord::Migration
  def self.up
    create_table :aliases, :force => true do |t|
      t.string :address, :null=> false
      t.text :goto, :null=> false
      t.belongs_to :dominio, :null=> false
      t.boolean :active, :null=> false, :default=> true

      t.timestamps
    end
  end

  def self.down
    drop_table :aliases
  end
end

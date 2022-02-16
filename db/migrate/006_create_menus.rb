class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus, :force => true do |t|
      t.string :label,:limit=> 60 , :null=>false
      t.string :url,:limit => 100, :null=>false
      t.integer :pai
      t.integer :ordem, :null=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :menus
  end
end

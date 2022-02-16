class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios, :force => true do |t|
      t.string :login, :limit => 40
      t.string :email, :limit => 100
      t.string :nome, :limit => 100
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.boolean :active, :default=> true
      t.timestamps 
    end
    user = Usuario.new
    user.login = "admin"
    user.email = "rayson@redesat-to.com.br"#FIXME Alterar o email para o do administrador
    user.password = "admin"
    user.password_confirmation = "admin"
    user.save(false) 
  end

  def self.down
    drop_table :usuarios
  end
end

class CreateGrupoUsuarios < ActiveRecord::Migration
  def self.up
    create_table :grupo_usuarios do |t|
      t.belongs_to :grupo, :null=> false
      t.belongs_to :usuario, :null=> false
      t.timestamps
    end
    #Adicionar o grupo "Super Administradores" ao usuário admin
    usuario = Usuario.find_by_login("admin")
    grupo= Grupo.find_by_nome("Super Administradores")
    GrupoUsuario.create(:usuario_id=> usuario.id, :grupo_id=> grupo.id) unless (usuario.nil? || grupo.nil?)
  end

  def self.down
    drop_table :grupo_usuarios
  end
end

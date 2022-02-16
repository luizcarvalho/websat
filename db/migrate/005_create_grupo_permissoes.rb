class CreateGrupoPermissoes < ActiveRecord::Migration
  def self.up
    create_table :grupo_permissoes do |t|
      t.belongs_to :permissao
      t.belongs_to :grupo
      t.timestamps
    end
    #Adicionar a permissao 'Geral', com o recurso ("*"), ao grupo 'Super Administradores'
    perm = Permissao.find_by_recurso("*")
    grupo= Grupo.find_by_nome("Super Administradores")
    GrupoPermissao.create(:permissao_id=> perm.id, :grupo_id=> grupo.id) unless (perm.nil? || grupo.nil?)    
  end

  def self.down
    drop_table :grupo_permissoes
  end
end

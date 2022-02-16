class CreateGrupos < ActiveRecord::Migration
  def self.up
    create_table :grupos, :force => true do |t|
      t.string :nome, :null=> false, :limit=> 100
      t.text :descricao
      t.timestamps
    end
    #Criar um grupo de usuário que dever ter acessos total ao sistema
    Grupo.create(:nome=>"Super Administradores", :descricao=>"Grupo de administradores que devem ter acesso total a todos os módulos do sistema.")
  end

  def self.down
    drop_table :grupos
    #Deletar o grupo de "Super Administradores"
    grupo = Grupo.find_by_nome("Super Administradores")
    grupo.destroy unless grupo.nil?
  end
end

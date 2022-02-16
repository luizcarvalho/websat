class CreatePermissoes < ActiveRecord::Migration
  def self.up
    create_table :permissoes, :force => true do |t|
      t.string :nome, :limit=> 100, :null=> false
      t.string :recurso, :limit=> 100, :null=> false
      t.timestamps
    end
    #Criação de uma permissao que dá acesso a todos os recursos do sistema
    Permissao.create(:nome=>"Geral", :recurso=> "*")
  end

  def self.down
    drop_table :permissoes
    #Deletar a permissão "Geral"
    perm = Permissao.find_by_nome("Geral")
    perm.destroy unless perm.nil?
  end
end

class Grupo < ActiveRecord::Base
  
  
  #Validations ------------------------------------------#
  validates_presence_of :nome,:within => 2..20
  validates_presence_of :descricao

  
  #Association
  has_many :grupo_usuarios, :dependent=> :destroy
  has_many :usuarios, :through=> :grupo_usuarios
  
  has_many :grupo_permissoes, :dependent=> :destroy
  has_many :permissoes, :through=> :grupo_permissoes
  
 
  
  #---------------------------------------------------------------------------
  
  #Apartir de permissões fornecidas pelo usuario
  #no formulario de criacao/edicao essas são 
  #associadas ao grupo atual
  #.#Luiz
  def create_permissoes(new_permissoes)
    unless new_permissoes.nil?
      new_permissoes.each do |item|
        grupo_permissoes.create(:permissao_id => item)
      end
    end
  end
  

 #--------------------------------------------------------------------------
 
 # Atualiza Permissoes apartir de um bloco de permissões passado como 
 # parametro, deletando permissões não mais utilziada ou adicionando
 # permissões que não existem.
 # 
 # ===== Opções
 # 
 # +new_permissoes+        Conjunto de permissoes que irá ser atualizado
 # 
 # ===== Exemplo:
 # 
 #    # Objeto passado pelo usuario
 #  new_permissoes = [usuario/new, usuario/edit, grupo/delete]
 # 
 #    # Dados Existentes no Banco
 #  old_permissoes = [usuario/new, usuario/delete, grupo/delete]
 #
 #    # Dados persistidos no banco
 #    Adiciona: usuario/edit
 #    Remove: usuario/delete
 #
 # #LUIZ
   def update_permissoes(new_permissoes)
    unless new_permissoes.nil?
      #Permissoes Existentes no Banco
      old_permissoes =  grupo_permissoes.collect{|gp| gp.permissao_id }
     
      #Permissoes que serão Deletadas
      delete_permissoes = old_permissoes - new_permissoes
      #Permissoes que Serão Adcionadas
      add_permissoes = new_permissoes - old_permissoes
     
      
      delete_permissoes.each do |item|
        grupo_permissoes.find_by_permissao_id(item).destroy
      end
      
      add_permissoes.each do |item|
        grupo_permissoes.create(:permissao_id => item)
      end
    end  
end
  
  
end

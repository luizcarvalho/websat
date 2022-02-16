class Permissao < ActiveRecord::Base


  #Validações ------------------------------------------#
  validates_presence_of :nome, :within => 3..40
  validates_presence_of :recurso
  #TODO Criar validação para recurso 
 
  #Association
  has_many :grupo_permissoes, :dependent=> :destroy
  has_many :usuarios, :through=> :grupo_permissoes 
end

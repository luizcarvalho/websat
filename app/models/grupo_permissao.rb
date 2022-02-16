class GrupoPermissao < ActiveRecord::Base
 
  #Associations 
  belongs_to :grupo
  belongs_to :permissao
end

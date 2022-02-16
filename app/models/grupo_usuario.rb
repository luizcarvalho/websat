class GrupoUsuario < ActiveRecord::Base
  
  #Associations 
  belongs_to :grupo
  belongs_to :usuario  
end

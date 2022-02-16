class Mailbox < ActiveRecord::Base
  #Associations
  belongs_to :usuario
  belongs_to :dominio
 
  #Validations
  validates_uniqueness_of :dominio_id,:scope =>:usuario_id

    
  before_create {|record| record.default_maildir}
   
  #TODO Criar variavel para armazenar a pasta do maildir
  def default_maildir
    dominio = Dominio.find(dominio_id)
    usuario = Usuario.find(usuario_id)
    self.maildir = "#{dominio.domain}/#{usuario.login}/Maildir/"
  end
  
  def to_s
    "#{usuario.login}@#{dominio.domain}"
  end
  
end

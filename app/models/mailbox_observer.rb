class MailboxObserver < ActiveRecord::Observer
  include Postfix
  
  def after_create(mailbox)
    begin
      Alias.create(:address=>mailbox.usuario.login,:goto=>"#{mailbox}",:dominio_id=>mailbox.dominio_id)
    rescue
      #TODO Gerar Log
      false
    end
    # criar alias : login@dominio ALIAS[:adress e :goto] 
    maildir =  "#{mailbox.homedir}/#{mailbox.dominio.domain}/#{mailbox.usuario.login}/"
    create_maildir maildir    
  end
  
  def after_destroy(mailbox)
    begin
    dalias = Alias.find_by_address(mailbox.usuario.login) 
    Alias.destroy(dalias)
    rescue
     #TODO Gerar Log
      false
    end
    
    
    #procura e destroy alias
    maildir =  "#{mailbox.homedir}/#{mailbox.dominio.domain}/#{mailbox.usuario.login}/"
    destroy_maildir maildir
  end
end

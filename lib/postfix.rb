module Postfix
 require 'net/ssh'
 require 'logger'
 
  #FIXME colocar no lugar das configurações
  MTA= {}
  MTA[:host]= '192.168.0.88'
    
    def create_maildir(maildir)
      log= Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}_ssh_debug.log") 
      #FIXME Verificar quando acontecer algum erro
      #FIXME Alterar a senha do maildrop no servidor ou tentar conectar por key
       Net::SSH.start(MTA[:host], 'maildrop', :password=>'maildrop', :verbose=>:debug ) do |ssh|  
        usuario_path = "#{maildir}/"
        maildir_path = "#{maildir}/Maildir"
        ssh.exec! "mkdir -p #{usuario_path}"
        result1 =ssh.exec! "maildirmake #{maildir_path}"
        log.debug "NET::SSH (maildirmake)- #{result1}" unless result1.blank?
        result2 =ssh.exec! "chown maildrop.maildrop -R #{usuario_path}"
        log.debug "NET::SSH (chown)- #{result2}" unless result2.blank?
        result3 =ssh.exec! "chmod 700 -R #{usuario_path}"
        log.debug "NET::SSH (chmod)- #{result3}" unless result3.blank?
        
       return  !result1 && !result2 && !result3
      
      end     
    end
  
    def destroy_maildir(mailbox)
      log= Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}_ssh_debug.log") 
      #   OPTIMIZE Verificar quando acontecer algum erro
      Net::SSH.start( MTA[:host], 'maildrop', :password=>'maildrop',  :verbose=>:debug ) do |ssh|  
        usuario_path = "#{mailbox}/"
        result= ssh.exec! "rm -r #{usuario_path}"
        log.debug "NET::SSH (rm - r #{usuario_path}): #{result}" unless result.blank?
      end      
    end
  
    def create_alias
    
    end
  
    def destroy_alias
    
    end   

end

class Ti::GruposController < ResourceController::Base
 
  #Filtra os grupos para um determinado usuário. 
  #Ex.: http://localhost:3000/usuario/1/grupos -> todos os grupos que são do usuario com id 1
  belongs_to:usuario
  
  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de grupos.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']
  
  before_filter :load_all_permissions

  #Expira todos os caches de menu quando um grupo for creado, alterado ou destruido
  cache_sweeper :all_sweeper,:only =>[:create,:update,:destroy]
  
  
  #Carrega todas as permissões, para ser adicionadas 
  #a um grupo quando for criar-lo/editar-lo 
  def load_all_permissions
    @permissoes = Permissao.find(:all)
  end
  
  #Cria o relacionamento entre o grupo e suas permissoes
  create.after do
    object.create_permissoes(params[:permissoes])
  end
  
  #Ao atualizar o grupo, Atualiza também os seus relacionamentos com
  #as Permissões
  update.after do
    object.update_permissoes(params[:permissoes])
  end
  
  private
  def collection
    @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => PER_PAGE
  end
end
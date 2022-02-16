class Ti::PermissoesController < ResourceController::Base
  
  cache_sweeper :all_sweeper,:only =>[:create,:update,:destroy]

  #Filtra as permissoes para um determinado grupo. 
  #Ex.: http://localhost:3000/grupos/1/permissoes -> todos as permissoes que são do grupo com id 1  
  belongs_to :grupo
  
  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de permissões.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']

  private
  def collection
    @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => PER_PAGE
  end
end
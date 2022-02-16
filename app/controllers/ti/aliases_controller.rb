class Ti::AliasesController < ResourceController::Base
  
  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de aliases.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']
  
  #Filtra os alias para um determinado domínio. 
  #Ex.: http://localhost:3000/dominios/1/aliases -> todos os alias que são do domínio com id 1
  belongs_to :dominio
  
  private
  def collection
    @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => PER_PAGE, :order => "aliases.address"
  end
end

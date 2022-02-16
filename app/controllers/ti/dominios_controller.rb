class Ti::DominiosController < ResourceController::Base
  
  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de domínios.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']
  
  private
  def collection
    @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => PER_PAGE, :order => "dominios.domain"
  end
end

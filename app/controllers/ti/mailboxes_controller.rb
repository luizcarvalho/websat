class Ti::MailboxesController < ResourceController::Base
  
  #Filtra os mailboxes para um determinado usuario. 
  #Ex.: http://localhost:3000/usuarios/1/mailboxes -> todos os mailboxes que são do usuario com id 1  
  belongs_to :usuario
  
  before_filter :filter_search, :only => :index
  
  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de mailboxes.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']
  
  private
  def collection
    @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => PER_PAGE, :conditions => @conditions, :order => "mailboxes.maildir"
  end 
end

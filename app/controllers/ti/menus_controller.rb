class Ti::MenusController < ResourceController::Base

def auto_complete_for_menus_to
  auto_complete_responder_for_urls params[:message][:to]
end

  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de menus.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']
  
  before_filter :load_pais
  before_filter :select_routes
  
  cache_sweeper :all_sweeper,:only =>[:create,:update,:destroy]

def load_pais
   @pais = Menu.find(:all,:conditions => "pai IS NULL").collect{|m| [m.label,m.id] }
end
  
#
# == Descrição
# Cria Hashs para utilização em selects tanto para controlles quanto para as actions
# * Controlles @ctrl_options
# * Actions @acts_options
#
# == Retornos
# @ctrl_options Retorna: {:controller1=>controller1,:controller2=>controller2}
# @acts_options Retorna: {:controller1/action1 => controller1/action1,<br>:controller1/action2=>controller1/action2,...}<br>
# #Luiz
def select_routes
  @cia = Menu.hash_controllers_and_actions
  @ctrl_options ={}
  @acts_options = {}
  
   @cia.keys.each do |ctrl|
      @ctrl_options.store(ctrl,ctrl)
      @cia[ctrl].each do |act| 
       @acts_options.store(ctrl+" / "+act,ctrl+"/"+act)
    end 
   end
end


  private
  def collection
    @collection ||= end_of_association_chain.paginate(:all, :include=>:menu_pai, :order=>"menus.ordem", :page => params[:page], :per_page => PER_PAGE)
  end  
end
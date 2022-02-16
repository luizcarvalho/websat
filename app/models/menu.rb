class Menu < ActiveRecord::Base

  has_many :menu_filhos, :class_name =>"Menu",:foreign_key => "pai",:dependent=>:destroy,:order=>"ordem"
  belongs_to :menu_pai, :class_name => "Menu",:foreign_key => "pai"
  
  validates_presence_of :label
  validates_presence_of :url
  
  
  #
  # == Descrição
  #     Metodo Coleta todas as rotas possiveis so sistema e forma um hash, onde
  #  os controlles são as chaves o valor é um array com as actions
  #  
  # == Exemplo
  # 
  #   usuario/new
  #   usuario/edit
  #   grupo/index
  #   cliente/destroy
  #   cliente/show
  # 
  # Gera : {usuario=>[new,edit],grupo=>[index],cliente=>[destroy,show]}
  # 
  #  == Utilização
  #   Um Exemplo de como você pode utilizar esse metodo
  #   
  #    Menu.hash_controllers_and_actions.keys.each do |controller|
  #      @cia[controller].each do  |action|  
  #           [controller,action]
  #      end
  #    end
  #
  #  RETORNA: {"controller1"=>["action1","action2","action3"],"controller2"=>["action1"],...}
  #
  # #Luiz

  def self.hash_controllers_and_actions
   unless @cia then
    @cia ={} #Controllers e Actions
    @ctrls = [] #Controlles
    @req = [] #conjunto de requirements
    @reques = ''#Auxiliar
    ActionController::Routing::Routes.routes.each do |route|     
      @ctrls.push(route.requirements[:controller])#Busco todos os Controlles
      @req.push(route.requirements)     #Pego os pares de Controllers e Actions
    end 
    @ctrls.uniq! #Tiro todos os Controllers Repetidos
    @ctrls.delete(nil)# e os Nulos
    @ctrls.collect { |c| @cia.store(c,[])} #Inicio a criação da estrutura colocando
                                           #os controlles e um arrray que irá conter
                                           #as Actions                                            
    @req.each do |req|
      @reqctrl = req[:controller] #busco em cada Requirement os controlles      
      unless @reqctrl.nil? #Verifico se ele eh nulo
                           #Pego todas as actions para aquele controller do requirement
        @cia[@reqctrl].push(req[:action]) unless ((@cia[@reqctrl]).include?(req[:action]))  
      end
    end
   end
    @cia
  end
  
 
  #
  # == Descrição
  # 
  #     Diferente do metodo hash_controllers_and_actions, este metodo retorna
  # um array contendo as dulas (Controller e actions) alem de um campo nulo
  # apenas com o controller.
  #
  #
  # == Exemplo
  # 
  #   usuario/new
  #   usuario/edit
  #   grupo/index
  #   cliente/destroy
  #   cliente/show
  # 
  #  Gera:   
  #         [["usuario",""],["usuario","new"],["usuario","edit"],["grupo","index"],
  #         ["cliente","destroy"],["cliente","show"]]
  #
  # === RETORNA: 
  #         [["controller1","action1"],["controller1","action2"],["controller2","action1"]]
  #
  
  def self.simple_controllers_and_actions
    @cia = hash_controllers_and_actions
    @duplaca = []
    
    @cia.keys.each do |ctrl|
      @duplaca.push([ctrl,""])
      @cia[ctrl].each do  |act| [ctrl,act] 
        @duplaca.push([ctrl,act])
      end
    end
        
    
   @duplaca 
  end
 
end

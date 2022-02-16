# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Messages
  include AuthenticatedSystem
  
  before_filter :permission_required
  
  #Gedilson - Paginate - Constante para a guarda a quantidade de itens que derão aparecer por vez na tabela.
  PER_PAGE = 16
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '995ebb44c8f8802296ae3ae3be0ec440'

  # Check if the usuario is authorized
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the usuario
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorized?
  #    current_usuario.login != "bob"
  #  end
  
  #Gedilson
  #Monta o sql necessário para o filtro solicitado pelo o usuário, a partir dos parametros
  #atribuidos a :search das respectivas views.
  def filter_search
    condition = nil
    hash_attributes = {}
    #Retorna todos os atributos e seus respectivos tipos do controller atual, atribuindo estes ao
    #hash => hash_attributes
    controller_name.singularize.classify.constantize.columns.collect {|c| hash_attributes[c.name] = c.type}
    
    unless params[:search].blank? then
      params[:search].each do |param|
        unless param[1].blank? then
          condition = [''] if condition.nil?
          condition[0] += ' and' unless condition[0].blank? 
          if (hash_attributes[param[0]] == :string) then
            param[1] += "%"
            condition[0] += " #{param[0].to_s} like ?"
          else
            condition[0] += " #{param[0].to_s} = ?"
          end
          condition.push(param[1].to_s)
        end       
      end
    end
    @conditions = condition
  end
  
  def authorized?
    login_required
    required_perm = "%s/%s" % [ params['controller'], params['action'] ]
    current_usuario.authorized?(required_perm)
  end
end
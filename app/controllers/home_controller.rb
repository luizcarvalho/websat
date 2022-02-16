class HomeController < ApplicationController
  
  before_filter :login_required

  #Filtros - Esse desobriga o usuario ter permissão para acessar, pois por padrão todos os controller percisam
  #ter permissão
  skip_before_filter :permission_required  
  
  def index
   
  end
end

class UsuariosController < ResourceController::Base

  actions :show
  
  #Filtros - Esse desobriga o usuario ter permissão para acessar, pois por padrão todos os controller percisam
  #ter permissão
  skip_before_filter :permission_required
  before_filter :login_required
  
  #Gedilson - Sobreescrita do flash das mensagens de atualização de inserção de usuarios.
  update.flash @@messages['successfully_updated']
  create.flash @@messages['successfully_created']
end

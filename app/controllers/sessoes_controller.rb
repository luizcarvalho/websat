# This controller handles the login/logout function of the site.  
class SessoesController < ApplicationController
  
  #Filtros - Esse desobriga o usuario ter permissão para acessar, pois por padrão todos os controller percisam
  #ter permissão
  skip_before_filter :permission_required  
  before_filter :not_logged_in_required, :only=> [:new, :create]
  before_filter :login_required, :only=> :destroy

  # render new.rhtml
  def new
  end

  def create
    self.current_usuario = Usuario.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_usuario.remember_me unless current_usuario.remember_token?
        cookies[:auth_token] = { :value => self.current_usuario.remember_token , :expires => self.current_usuario.remember_token_expires_at }        
      end
      redirect_back_or_default(home_path)
      flash[:notice] = @@messages['login_successful']
    else
      flash[:notice] = @@messages['user_and_or_incorrect_password']
      render :action => 'new'
    end
  end

  def destroy
    self.current_usuario.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = @@messages['exit_system']
    redirect_back_or_default(root_path)
  end
end
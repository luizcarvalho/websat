class PasswordsController < ApplicationController

  #Filtros - Esse desobriga o usuario ter permissão para acessar, pois por padrão todos os controller percisam
  #ter permissão
  skip_before_filter :permission_required      
  before_filter :login_required
  
  def edit
  end

  # Change password action  
  def update
    if Usuario.authenticate(self.current_usuario.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_usuario.password_confirmation = params[:password_confirmation]
        current_usuario.password = params[:password]        
        if current_usuario.save
          flash[:notice] = @@messages['password_successfully_amended']
          redirect_to home_path #profile_url(current_user.login)
        else
          flash[:error] = @@messages['error_change_password']
          render :action => 'edit'
        end
      else
        flash[:error] = @@messages['new_not_password_confirmation']
        @old_password = params[:old_password]
        render :action => 'edit'      
      end
    else
      flash[:error] = @@messages['old_password_wrong']
      render :action => 'edit'
    end 
  end  
end
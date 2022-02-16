module AuthenticatedSystem
  protected
  # Returns true or false if the usuario is logged in.
  # Preloads @current_usuario with the usuario model if they're logged in.
  def logged_in?
    !!current_usuario
  end

  # Accesses the current usuario from the session. 
  # Future calls avoid the database because nil is not equal to false.
  def current_usuario
    @current_usuario ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_usuario == false
  end

  # Store the given usuario id in the session.
  def current_usuario=(new_usuario)
    session[:usuario_id] = new_usuario ? new_usuario.id : nil
    @current_usuario = new_usuario || false
  end

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
  def authorized?
    logged_in?
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    logged_in? || access_denied
  end

  # Filter method to enforce a permission requirement.
  #
  # To require logins and permissions for all actions, use this in your controllers:
  #
  #   before_filter :permission_required
  #
  # To require logins and permissions for specific actions, use this in your controllers:
  #
  #   before_filter :permission_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :permission_required
  #
  def permission_required
    authorized? || permission_denied
  end
  
  # Filter method to enforce a not login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :not_logged_in_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :not_logged_in_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :not_logged_in_required
  #    
  def not_logged_in_required
    !logged_in? || permission_denied
  end
  
  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the usuario is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |format|
      format.html do
        #TODO Precisa usar uma classe para reunir todas as mensagens
        flash[:error]= "Você tentou acessar uma área restrita e para tanto precisa estar logado!"
        store_location
        redirect_to new_sessao_path
      end
      format.any do
        request_http_basic_authentication 'WebSat'
      end
    end
  end

  # Redirect as appropriate when an permission request fails.
  #
  # The default action is to redirect to the home screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the usuario is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def permission_denied
    respond_to do |format|
      format.html do
        #TODO Precisa usar uma classe para reunir todas as mensagens
        flash[:error]= "Você tentou acessar uma área restrita na qual não possui permissão!"
        redirect_to home_path
      end
      format.any do
        request_http_basic_authentication 'WebSat'
      end
    end
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_usuario and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_usuario, :logged_in?
  end

  # Called from #current_usuario.  First attempt to login by the usuario id stored in the session.
  def login_from_session
    self.current_usuario = Usuario.find_by_id(session[:usuario_id]) if session[:usuario_id]
  end

  # Called from #current_usuario.  Now, attempt to login by basic authentication information.
  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_usuario = Usuario.authenticate(username, password)
    end
  end

  # Called from #current_usuario.  Finaly, attempt to login by an expiring token in the cookie.
  def login_from_cookie
    usuario = cookies[:auth_token] && Usuario.find_by_remember_token(cookies[:auth_token])
    if usuario && usuario.remember_token?
      cookies[:auth_token] = { :value => usuario.remember_token, :expires => usuario.remember_token_expires_at }
      self.current_usuario = usuario
    end
  end
end

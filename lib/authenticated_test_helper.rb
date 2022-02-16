module AuthenticatedTestHelper
  # Sets the current usuario in the session from the usuario fixtures.
  def login_as(usuario)
    @request.session[:usuario_id] = usuario ? usuarios(usuario).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end

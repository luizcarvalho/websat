require File.dirname(__FILE__) + '/../test_helper'
require 'grupos_controller'

# Re-raise errors caught by the controller.
class GruposController; def rescue_action(e) raise e end; end

class GruposControllerTest < Test::Unit::TestCase
  fixtures :grupos

  def setup
    @controller = GruposController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:grupos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_grupo
    old_count = Grupo.count
    post :create, :grupo => { }
    assert_equal old_count+1, Grupo.count
    
    assert_redirected_to grupo_path(assigns(:grupo))
  end

  def test_should_show_grupo
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_grupo
    put :update, :id => 1, :grupo => { }
    assert_redirected_to grupo_path(assigns(:grupo))
  end
  
  def test_should_destroy_grupo
    old_count = Grupo.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Grupo.count
    
    assert_redirected_to grupos_path
  end
end

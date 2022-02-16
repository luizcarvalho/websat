require File.dirname(__FILE__) + '/../test_helper'
require 'dominios_controller'

# Re-raise errors caught by the controller.
class DominiosController; def rescue_action(e) raise e end; end

class DominiosControllerTest < Test::Unit::TestCase
  fixtures :dominios

  def setup
    @controller = DominiosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:dominios)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_dominio
    old_count = Dominio.count
    post :create, :dominio => { }
    assert_equal old_count+1, Dominio.count
    
    assert_redirected_to dominio_path(assigns(:dominio))
  end

  def test_should_show_dominio
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_dominio
    put :update, :id => 1, :dominio => { }
    assert_redirected_to dominio_path(assigns(:dominio))
  end
  
  def test_should_destroy_dominio
    old_count = Dominio.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Dominio.count
    
    assert_redirected_to dominios_path
  end
end

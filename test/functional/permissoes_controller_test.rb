require File.dirname(__FILE__) + '/../test_helper'
require 'permissoes_controller'

# Re-raise errors caught by the controller.
class PermissoesController; def rescue_action(e) raise e end; end

class PermissoesControllerTest < Test::Unit::TestCase
  fixtures :permissoes

  def setup
    @controller = PermissoesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:permissoes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_permissao
    old_count = Permissao.count
    post :create, :permissao => { }
    assert_equal old_count+1, Permissao.count
    
    assert_redirected_to permissao_path(assigns(:permissao))
  end

  def test_should_show_permissao
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_permissao
    put :update, :id => 1, :permissao => { }
    assert_redirected_to permissao_path(assigns(:permissao))
  end
  
  def test_should_destroy_permissao
    old_count = Permissao.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Permissao.count
    
    assert_redirected_to permissoes_path
  end
end

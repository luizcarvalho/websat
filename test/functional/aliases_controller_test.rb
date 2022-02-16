require File.dirname(__FILE__) + '/../test_helper'
require 'aliases_controller'

# Re-raise errors caught by the controller.
class AliasesController; def rescue_action(e) raise e end; end

class AliasesControllerTest < Test::Unit::TestCase
  fixtures :aliases

  def setup
    @controller = AliasesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:aliases)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_alias
    old_count = Alias.count
    post :create, :alias => { }
    assert_equal old_count+1, Alias.count
    
    assert_redirected_to alias_path(assigns(:alias))
  end

  def test_should_show_alias
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_alias
    put :update, :id => 1, :alias => { }
    assert_redirected_to alias_path(assigns(:alias))
  end
  
  def test_should_destroy_alias
    old_count = Alias.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Alias.count
    
    assert_redirected_to aliases_path
  end
end

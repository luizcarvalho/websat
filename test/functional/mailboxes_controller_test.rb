require File.dirname(__FILE__) + '/../test_helper'
require 'mailboxes_controller'

# Re-raise errors caught by the controller.
class MailboxesController; def rescue_action(e) raise e end; end

class MailboxesControllerTest < Test::Unit::TestCase
  fixtures :mailboxes

  def setup
    @controller = MailboxesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:mailboxes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_mailbox
    old_count = Mailbox.count
    post :create, :mailbox => { }
    assert_equal old_count+1, Mailbox.count
    
    assert_redirected_to mailbox_path(assigns(:mailbox))
  end

  def test_should_show_mailbox
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_mailbox
    put :update, :id => 1, :mailbox => { }
    assert_redirected_to mailbox_path(assigns(:mailbox))
  end
  
  def test_should_destroy_mailbox
    old_count = Mailbox.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Mailbox.count
    
    assert_redirected_to mailboxes_path
  end
end

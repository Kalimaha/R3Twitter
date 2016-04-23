require 'test_helper'

class UserControllerTest < ActionController::TestCase

  def setup
    @ctrl = UserController.new
    @ctrl.init_redis
    @ctrl.flushdb
    @user_1 = {username: 'pippo', password: '12345678'}
    @user_2 = {username: 'pluto', password: '87654321'}
  end

  def test_login
    assert_generates '/login', controller: 'user', action: 'login'
    post :login
    assert_redirected_to '/'
    assert_not_nil flash[:error]
    post :login, {username: 'pippo'}
    assert_redirected_to '/'
    assert_not_nil flash[:error]
    post :login, {username: 'pippo', password: '12345678'}
    # assert_redirected_to '/'
  end

  def test_register
    assert_generates '/register', controller: 'user', action: 'register'
    post :register
    assert_redirected_to '/'
    assert_not_nil flash[:error]
    post :register, {new_username: 'pippo'}
    assert_redirected_to '/'
    assert_not_nil flash[:error]
    post :register, {new_username: 'pippo', new_password: '12345678'}
    assert_redirected_to '/'
    assert_not_nil flash[:error]
    post :register, {new_username: 'pippo', new_password: '12345678', confirm_password: '87654321'}
    assert_redirected_to '/'
    assert_not_nil flash[:error]
    post :register, {new_username: 'pippo', new_password: '12345678', confirm_password: '12345678'}
    assert_redirected_to '/'
    assert_not_nil flash[:success]
  end

end
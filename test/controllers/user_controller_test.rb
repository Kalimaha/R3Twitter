require 'test_helper'

class UserControllerTest < ActionController::TestCase

  include UserHelper

  def setup
    init_redis
    flushdb
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
    create_user(@user_1)
    post :login, {username: 'pippo', password: '12345678'}
    assert_redirected_to '/tweets/pippo'
    assert_not_nil session[:username]
    assert_equal @user_1[:username], session[:username]
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

  def test_create_following
    create_user(@user_1)
    create_user(@user_2)
    get :create_following, {first_user_id: 1, second_user_id: 2}
    assert_redirected_to '/tweets/' + @user_1[:username]
  end

end
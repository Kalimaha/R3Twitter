require 'test_helper'

class UserControllerTest < ActionController::TestCase

  def setup
    @ctrl = UserController.new
    @ctrl.flushdb
    @user_1 = {username: 'kalimaha', password: '12345678'}
    @user_2 = {username: 'orcrist', password: '87654321'}
  end

  def test_flushdb
    assert_equal 'OK', @ctrl.flushdb
  end

  def test_redis
    assert_not_nil @ctrl.redis
  end

  def test_get_id
    assert_equal 1, @ctrl.get_id
  end

  def test_get_next_id
    assert_equal 1, @ctrl.get_next_id
  end

  def test_create_user
    assert_equal 'OK', @ctrl.create_user(@user_1)
    assert_equal 'OK', @ctrl.create_user(@user_2)
  end

  def test_exists?
    assert_not @ctrl.exists?(@user_1['username'])
    @ctrl.create_user(@user_1)
    assert @ctrl.exists?(@user_1['username'])
  end

  def test_get_user_id
    @ctrl.create_user(@user_1)
    assert_equal '1', @ctrl.get_user_id(@user_1['username'])
  end

  def test_get_user
    @ctrl.create_user(@user_1)
    user_id = @ctrl.get_user_id(@user_1['username'])
    assert_equal '1', user_id
    user = @ctrl.get_user(user_id)
    assert_not_nil user
    assert_equal 'kalimaha', user['username']
    assert_equal '12345678', user['password']
  end

  def test_login
    assert_generates '/login', controller: 'user', action: 'login'
  end

  def test_register
    assert_generates '/register', controller: 'user', action: 'register'
    post :register
    assert_redirected_to controller: 'user', action: 'login'
    post :register, {new_username: 'kalimaha'}
    assert_redirected_to controller: 'user', action: 'login'
    post :register, {new_username: 'kalimaha', new_password: '12345678'}
    assert_redirected_to controller: 'user', action: 'login'
    post :register, {new_username: 'kalimaha', new_password: '12345678', confirm_password: '87654321'}
    assert_redirected_to controller: 'user', action: 'login'
    post :register, {new_username: 'kalimaha', new_password: '12345678', confirm_password: '12345678'}
    assert_redirected_to '/'
    assert_not_nil flash[:success]
  end

end
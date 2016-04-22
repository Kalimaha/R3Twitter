require 'test_helper'

class UserControllerTest < ActionController::TestCase

  def setup
    @ctrl = UserController.new
    @ctrl.use_test_db
    @ctrl.flushdb
    @user_1 = {username: 'pippo', password: '12345678'}
    @user_2 = {username: 'pluto', password: '87654321'}
  end

  def test_flushdb
    assert_equal 'OK', @ctrl.flushdb
  end

  def test_redis
    assert_not_nil @ctrl.namespaced
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
    assert_equal 'pippo', user['username']
    assert_equal '12345678', user['password']
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

  def test_valid_login_params
    params = {}
    assert_not @ctrl.valid_login_params?(params)
    params = {username: ''}
    assert_not @ctrl.valid_login_params?(params)
    params = {password: ''}
    assert_not @ctrl.valid_login_params?(params)
    params = {username: '', password: ''}
    assert_not @ctrl.valid_login_params?(params)
    params = {username: 'kalimaha', password: '12345678'}
    assert @ctrl.valid_login_params?(params)
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

  def test_valid_registration_params
    params = {}
    assert_not @ctrl.valid_registration_params?(params)
    params = {new_username: ''}
    assert_not @ctrl.valid_registration_params?(params)
    params = {new_password: ''}
    assert_not @ctrl.valid_registration_params?(params)
    params = {confirm_password: ''}
    assert_not @ctrl.valid_registration_params?(params)
    params = {new_username: 'pluto', new_password: '20071982', confirm_password: '201071919'}
    assert_not @ctrl.valid_registration_params?(params)
    params = {new_username: 'pluto', new_password: '20071982', confirm_password: '20071982'}
    assert @ctrl.valid_registration_params?(params)
  end

  def test_follow
    assert @ctrl.follow('42', '1')
  end

  def test_get_following
    @ctrl.follow('42', '1')
    @ctrl.follow('42', '3')
    @ctrl.follow('42', '7')
    following = @ctrl.get_following('42')
    assert following.include? '1'
    assert following.include? '3'
    assert following.include? '7'
  end

  def test_get_followers
    @ctrl.follow('42', '1')
    @ctrl.follow('42', '3')
    @ctrl.follow('42', '7')
    followers = @ctrl.get_followers('1')
    assert followers.include? '42'
    followers = @ctrl.get_followers('3')
    assert followers.include? '42'
    followers = @ctrl.get_followers('7')
    assert followers.include? '42'
  end

end
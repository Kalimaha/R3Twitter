require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  include UserHelper

  def setup
    init_redis
    @user_1 = {username: 'pippo', password: '12345678'}
  end

  def teardown
    flushdb
  end

  def test_get_id
    assert_equal 1, get_id
  end

  def test_get_next_id
    assert_equal 1, get_next_id
  end

  def test_create_user
    assert_equal 'OK', create_user(@user_1)
  end

  def test_exists?
    assert_not exists?(@user_1['username'])
    create_user(@user_1)
    assert exists?(@user_1['username'])
  end

  def test_get_user_id
    create_user(@user_1)
    assert_equal '1', get_user_id(@user_1['username'])
  end

  def test_get_user
    create_user(@user_1)
    user_id = get_user_id(@user_1['username'])
    assert_equal '1', user_id
    user = get_user(user_id)
    assert_not_nil user
    assert_equal 'pippo', user['username']
    assert_equal '12345678', user['password']
  end

  def test_valid_login_params
    params = {}
    assert_not valid_login_params?(params)
    params = {username: ''}
    assert_not valid_login_params?(params)
    params = {password: ''}
    assert_not valid_login_params?(params)
    params = {username: '', password: ''}
    assert_not valid_login_params?(params)
    params = {username: 'pippo', password: '12345678'}
    assert valid_login_params?(params)
  end

  def test_valid_registration_params
    params = {}
    assert_not valid_registration_params?(params)
    params = {new_username: ''}
    assert_not valid_registration_params?(params)
    params = {new_password: ''}
    assert_not valid_registration_params?(params)
    params = {confirm_password: ''}
    assert_not valid_registration_params?(params)
    params = {new_username: 'pluto', new_password: '20071982', confirm_password: '201071919'}
    assert_not valid_registration_params?(params)
    params = {new_username: 'pluto', new_password: '20071982', confirm_password: '20071982'}
    assert valid_registration_params?(params)
  end

  def test_follow
    assert follow('42', '1')
  end

  def test_get_following
    follow('42', '1')
    follow('42', '3')
    follow('42', '7')
    following = get_following('42')
    assert following.include? '1'
    assert following.include? '3'
    assert following.include? '7'
  end

  def test_get_followers
    follow('42', '1')
    follow('42', '3')
    follow('42', '7')
    followers = get_followers('1')
    assert followers.include? '42'
    followers = get_followers('3')
    assert followers.include? '42'
    followers = get_followers('7')
    assert followers.include? '42'
  end

end
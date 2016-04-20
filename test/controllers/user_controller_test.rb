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
    assert_equal "1", @ctrl.get_user_id(@user_1['username'])
  end

end
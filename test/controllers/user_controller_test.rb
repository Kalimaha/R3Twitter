require 'test_helper'

class UserControllerTest < ActionController::TestCase

  def setup
    @ctrl = UserController.new
    @ctrl.flushdb
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

end
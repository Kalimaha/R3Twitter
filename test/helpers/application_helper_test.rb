require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def setup
    init_redis
  end

  def test_init
    assert_not_nil @redis
  end

  def test_flushdb
    assert_equal 'OK', flushdb
  end

end
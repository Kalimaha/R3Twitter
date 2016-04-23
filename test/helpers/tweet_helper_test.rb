require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  include UserHelper, TweetHelper

  def setup
    init_redis
    @user_1 = {username: 'pippo', password: '12345678'}
    @tweet_1 = {body: 'Hello, World!'}
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

end
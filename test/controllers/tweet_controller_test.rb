require 'test_helper'
require 'date'

class TweetControllerTest < ActionController::TestCase

  def setup
    @ctrl = TweetController.new
    @ctrl.use_test_db
    @ctrl.flushdb
    @tweet_1 = {username: 'kalimaha', body: 'Hello, world!', time: DateTime.now.strftime('%Q')}
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

  def test_create_tweet
    assert_equal 1, @ctrl.create_tweet(@tweet_1)
  end

end

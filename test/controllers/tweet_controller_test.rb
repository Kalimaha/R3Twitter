require 'test_helper'

class TweetControllerTest < ActionController::TestCase

  def setup
    @ctrl = TweetController.new
    @ctrl.use_test_db
    @ctrl.flushdb
    @tweet_1 = {body: 'Hello, World!'}
    @user_1 = {username: 'kalimaha', password: '12345678'}
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
    @ctrl.create_user(@user_1)
    assert_equal 'OK', @ctrl.create_tweet(@user_1['username'], @tweet_1)
  end

  def test_get_tweets
    @ctrl.create_user(@user_1)
    @ctrl.create_tweet(@user_1['username'], @tweet_1)
    tweets = @ctrl.get_tweets(@user_1['username'])
    assert tweets.length == 1
    assert_equal 'Hello, World!', tweets.first['body']
  end

end
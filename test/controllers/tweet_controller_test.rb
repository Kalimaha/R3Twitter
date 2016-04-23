require 'test_helper'

class TweetControllerTest < ActionController::TestCase

  def setup
    @user_ctrl = UserController.new
    @user_ctrl.init_redis
    @user_ctrl.flushdb
    @tweet_ctrl = TweetController.new
    @tweet_ctrl.init_redis
    @tweet_ctrl.flushdb
    @tweet_1 = {body: 'Hello, World!'}
    @user_1 = {username: 'pippo', password: '12345678'}
  end

  def test_flushdb
    assert_equal 'OK', @tweet_ctrl.flushdb
  end

  def test_redis
    assert_not_nil @tweet_ctrl.redis
  end

  def test_get_id
    assert_equal 1, @tweet_ctrl.get_id
  end

  def test_get_next_id
    assert_equal 1, @tweet_ctrl.get_next_id
  end

  def test_create_tweet
    @user_ctrl.create_user(@user_1)
    assert_equal 'OK', @tweet_ctrl.create_tweet(@user_1['username'], @tweet_1)
  end

  def test_get_tweets
    @user_ctrl.create_user(@user_1)
    @tweet_ctrl.create_tweet(@user_1['username'], @tweet_1)
    tweets = @tweet_ctrl.get_tweets(@user_1['username'])
    assert tweets.length == 1
    assert_equal 'Hello, World!', tweets.first['body']
  end

end
require 'test_helper'

class TweetControllerTest < ActionController::TestCase

  include UserHelper, TweetHelper

  def setup
    init_redis
    flushdb
    @tweet_1 = {body: 'Hello, World!', user_id: 1}
    @user_1 = {username: 'pippo', password: '12345678'}
  end

  def test_create
    create_user(@user_1)
    post :create, {username: 'pippo', tweet: @tweet_1}
    assert_redirected_to '/tweets/pippo'
  end

end
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

end
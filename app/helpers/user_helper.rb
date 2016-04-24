module UserHelper

  include ApplicationHelper

  def get_id
    @redis.get('user_id') != nil ? @redis.get('user_id') : get_next_id
  end

  def get_next_id
    @redis.incr 'user_id'
  end

  def create_user(user)
    user_id = get_next_id
    @redis.hset('users', user[:username], user_id)
    @redis.mapped_hmset(user_id, user)
  end

  def exists?(username)
    @redis.hget('users', username) != nil
  end

  def get_user_id(username)
    @redis.hget('users', username)
  end

  def get_user(user_id)
    @redis.hgetall(user_id)
  end

  def valid_login_params?(params)
    params[:username] != nil &&
        params[:username].length > 0 &&
        params[:password] != nil &&
        params[:password].length > 0
  end

  def valid_registration_params?(params)
    params[:new_username] != nil &&
        params[:new_username].length > 0 &&
        params[:new_password] != nil &&
        params[:new_password].length > 0 &&
        params[:confirm_password] != nil &&
        params[:confirm_password].length > 0 &&
        params[:new_password] == params[:confirm_password]
  end

  def follow(user_id, following_id)
    @redis.zadd('following:' + user_id, DateTime.now.strftime('%Q'), following_id) &&
        @redis.zadd('followers:' + following_id, DateTime.now.strftime('%Q'), user_id)
  end

  def get_following(user_id)
    @redis.zrevrange('following:' + user_id, 0, -1)
  end

  def get_followers(user_id)
    @redis.zrevrange('followers:' + user_id, 0, -1)
  end

end
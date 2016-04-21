require 'redis'
require 'date'

class UserController < ApplicationController

  attr_reader :namespaced

  skip_before_filter :verify_authenticity_token

  def initialize
    super
    @redis = Redis.new
    @namespaced = Redis::Namespace.new(:production, :redis => @redis)
  end

  def use_test_db
    @namespaced = Redis::Namespace.new(:test, :redis => @redis)
  end

  def index
  end

  def flushdb
    keys = @namespaced.keys('*')
    @namespaced.del(*keys) unless keys.empty?
    'OK'
  end

  def get_id
    @namespaced.get('user_id') != nil ? @namespaced.get('user_id') : get_next_id
  end

  def get_next_id
    @namespaced.incr 'user_id'
  end

  def create_user(user)
    user_id = get_next_id
    @namespaced.hset('users', user['username'], user_id)
    @namespaced.mapped_hmset(user_id, user)
  end

  def exists?(username)
    @namespaced.hget('users', username) != nil
  end

  def get_user_id(username)
    @namespaced.hget('users', username)
  end

  def get_user(user_id)
    @namespaced.hgetall(user_id)
  end

  def login
    if valid_login_params?(params)
      if exists?(params[:username])
        @user = get_user(get_user_id(params[:username]))
        redirect_to '/tweets/' + @user['username']
      else
        flash[:error] = "User <i>#{params[:username]}</i> does NOT exists. Please register."
        redirect_to '/'
      end
    else
      flash[:error] = 'Please provide your username and password.'
      redirect_to '/'
    end
  end

  def valid_login_params?(params)
    params[:username] != nil &&
    params[:username].length > 0 &&
    params[:password] != nil &&
    params[:password].length > 0
  end

  def register
    if valid_registration_params?(params)
      user = Hash.new
      user['username'] = params[:new_username]
      user['password'] = params[:new_password]
      if create_user(user) == 'OK'
        flash[:success] = 'Registration complete, please login.'
        redirect_to '/'
        return
      else
        flash[:error] = 'Registration failed. Please try again.'
        redirect_to '/'
        return
      end
    else
      flash[:error] = 'Please enter an username, a password, and a matching confirmation password.'
      redirect_to '/'
    end
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
    @namespaced.zadd('following:' + user_id, DateTime.now.strftime('%Q'), following_id) &&
    @namespaced.zadd('followers:' + following_id, DateTime.now.strftime('%Q'), user_id)
  end

  def get_following(user_id)
    @namespaced.zrevrange('following:' + user_id, 0, -1)
  end

  def get_followers(user_id)
    @namespaced.zrevrange('followers:' + user_id, 0, -1)
  end

end
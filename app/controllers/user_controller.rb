require 'redis'

class UserController < ApplicationController

  attr_reader :redis

  skip_before_filter :verify_authenticity_token

  def initialize
    super
    @redis = Redis.new
  end

  def index
  end

  def flushdb
    @redis.flushdb
  end

  def get_id
    @redis.get('user_id') != nil ? @redis.get('user_id') : get_next_id
  end

  def get_next_id
    @redis.incr 'user_id'
  end

  def create_user(user)
    user_id = get_next_id
    @redis.hset('users', user['username'], user_id)
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

  def login
    if valid_login_params?(params)
      if exists?(params[:username])
        @user = get_user(get_user_id(params[:username]))
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

end
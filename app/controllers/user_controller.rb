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

    # Check input parameters.
    if params[:username].length < 1
      flash[:error] = 'Please provide your username.'
      redirect_to '/'
    elsif params[:password].length < 1
      flash[:error] = 'Please provide your password.'
      redirect_to '/'
    else
      puts params[:username]
      puts exists?(params[:username])
      if exists?(params[:username])
        @user = get_user(get_user_id(params[:username]))
      else
        flash[:error] = "User <i>#{params[:username]}</i> does NOT exists. Please register."
        redirect_to '/'
      end
    end

  end

  def register
    if params[:new_password] != params[:confirm_password]
      flash[:error] = 'Passwords do not match.'
      redirect_to '/'
    end
    user = Hash.new
    user['username'] = params[:new_username]
    user['password'] = params[:new_password]
    flash[:success] = 'Registration complete, please login.'
    redirect_to '/'
  end

end
require 'redis'

class UserController < ApplicationController

  attr_reader :redis

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

end
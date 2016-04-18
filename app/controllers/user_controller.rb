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
    @redis.mapped_hmset(get_next_id, user)
  end

end
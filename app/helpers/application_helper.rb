module ApplicationHelper

  attr_reader :redis

  @redis = nil

  def init_redis
    @redis = Redis.new(:host => Rails.configuration.x.redis.host,
                       :port => Rails.configuration.x.redis.port,
                       :password => Rails.configuration.x.redis.password) if @redis == nil
  end

  # Empty the DB. This method is used in the testing environment.
  def flushdb
    keys = @redis.keys('*')
    @redis.del(*keys) unless keys.empty?
    'OK'
  end

end
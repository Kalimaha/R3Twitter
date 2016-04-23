module ApplicationHelper

  attr_reader :namespaced

  @redis = nil

  @namespaced = nil

  def init_redis
    @redis = Redis.new(:host => Rails.configuration.x.redis.host,
                       :port => Rails.configuration.x.redis.port,
                       :password => Rails.configuration.x.redis.password) if @redis == nil
    @namespaced = Redis::Namespace.new(:production, :redis => @redis) if @namespaced == nil
  end

  def use_test_db
    @namespaced = Redis::Namespace.new(:test, :redis => @redis)
  end

  def flushdb
    keys = @namespaced.keys('*')
    @namespaced.del(*keys) unless keys.empty?
    'OK'
  end

end
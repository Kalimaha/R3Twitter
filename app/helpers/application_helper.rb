module ApplicationHelper

  attr_reader :namespaced

  @redis = nil

  @namespaced = nil

  def init_redis
    @redis = Redis.new(:host => 'ec2-54-227-252-91.compute-1.amazonaws.com',
                       :port => 15059,
                       :password => 'pfggp9e08scbba7dd4nvc488u2f') if @redis == nil
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
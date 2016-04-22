module ApplicationHelper

  attr_reader :namespaced

  def initialize
    @redis = Redis.new
    @namespaced = Redis::Namespace.new(:production, :redis => @redis)
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
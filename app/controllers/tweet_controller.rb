require 'redis'

class TweetController < ApplicationController

  attr_reader :namespaced

  def initialize
    super
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

  def get_id
    @namespaced.get('tweet_id') != nil ? @namespaced.get('tweet_id') : get_next_id
  end

  def get_next_id
    @namespaced.incr 'tweet_id'
  end

  def create_tweet(tweet)
    tweet_id = get_next_id
    @namespaced.mapped_hmset(tweet_id, tweet)
    tweet_id
  end

end
class TweetController < ApplicationController

  include TweetHelper

  def new
    @username = params[:username]
  end

  def create
    tweet = {body: params[:message]}
    create_tweet(params[:username], tweet)
    redirect_to '/tweets/' + params[:username]
  end

  def retrieve
    @username = params[:username]
    @tweets = get_tweets(@username)
    followers_ids = get_followers(get_user_id(@username))
    following_ids = get_following(get_user_id(@username))
    @followers = []
    @following = []
    followers_ids.each {|id| @followers << get_user(id)}
    following_ids.each {|id| @following << get_user(id)}
  end

  def get_tweets(username)
    user_id = get_user_id(username)
    @tweets = []
    tweet_ids = @redis.lrange('tweets:' + user_id, 0, -1)
    tweet_ids.each do |id|
      tweet = @redis.hgetall(id)
      tweet['username'] = get_user(tweet['user_id'])['username']
      tweet['body'] = highlight(tweet['body'])
      @tweets << tweet
    end
    @tweets
  end

end
class TweetController < UserController

  def get_id
    @namespaced.get('tweet_id') != nil ? @namespaced.get('tweet_id') : get_next_id
  end

  def get_next_id
    @namespaced.incr 'tweet_id'
  end

  def new
    @username = params[:username]
  end

  def create
    puts params
    tweet = {body: params[:message]}
    create_tweet(params[:username], tweet)
    redirect_to '/tweets/' + params[:username]
  end

  def create_tweet(username, tweet)
    user_id = get_user_id(username)
    tweet['user_id'] = user_id
    tweet['time'] = DateTime.now.strftime('%Q')
    tweet_id = get_next_id
    @namespaced.mapped_hmset(tweet_id, tweet)
    followers = get_followers(user_id)
    followers << user_id
    followers.each {|f| @namespaced.lpush('tweets:' + f, tweet_id)}
    'OK'
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
    tweet_ids = @namespaced.lrange('tweets:' + user_id, 0, -1)
    tweet_ids.each do |id|
        tweet = @namespaced.hgetall(id)
        tweet['username'] = get_user(tweet['user_id'])['username']
        @tweets << tweet
    end
    @tweets
  end

end
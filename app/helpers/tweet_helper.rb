module TweetHelper

  include UserHelper

  def get_id
    @redis.get('tweet_id') != nil ? @redis.get('tweet_id') : get_next_id
  end

  def get_next_id
    @redis.incr 'tweet_id'
  end

  def create_tweet(username, tweet)
    user_id = get_user_id(username)
    tweet['user_id'] = user_id
    tweet['time'] = DateTime.now.strftime('%Q')
    tweet_id = get_next_id
    @redis.mapped_hmset(tweet_id, tweet)
    followers = get_followers(user_id)
    followers << user_id
    followers.each {|f| @redis.lpush('tweets:' + f, tweet_id)}
    'OK'
  end

  # Wrap _hashtags_ and _at_ references with HTML anchors.
  #
  # ==== Inputs
  # * +message+ The original message.
  # ==== Output
  # * +message+ The modified message.
  def highlight(message)
    highlight_hashtags(message)
    highlight_at(message)
  end

  def highlight_hashtags(message)
    tags = message.scan(/#\w+/).flatten
    tags.each {|t| message.gsub!(t, '<a target="_blank" href="https://en.wikipedia.org/w/index.php?search=' + t[1..-1] + '">' + t + '</a>') }
    message
  end

  def highlight_at(message)
    tags = message.scan(/@\w+/).flatten
    tags.each {|t| message.gsub!(t, '<a href="/tweets/' + t[1..-1] + '">' + t + '</a>') }
    message
  end

end
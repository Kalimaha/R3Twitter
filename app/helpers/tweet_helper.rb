module TweetHelper

  include UserHelper

  def get_id
    @namespaced.get('tweet_id') != nil ? @namespaced.get('tweet_id') : get_next_id
  end

  def get_next_id
    @namespaced.incr 'tweet_id'
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

  def highlight(message)
    highlight_hashtags(message)
    highlight_at(message)
  end

  private
  def highlight_hashtags(message)
    tags = message.scan(/#\w+/).flatten
    tags.each {|t| message.gsub!(t, '<a target="_blank" href="https://en.wikipedia.org/w/index.php?search=' + t[1..-1] + '">' + t + '</a>') }
    message
  end

  private
  def highlight_at(message)
    tags = message.scan(/@\w+/).flatten
    tags.each {|t| message.gsub!(t, '<a href="/tweets/' + t[1..-1] + '">' + t + '</a>') }
    message
  end

end
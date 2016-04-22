module TweetHelper

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
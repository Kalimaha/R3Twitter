require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  include UserHelper, TweetHelper

  def setup
    init_redis
    @user_1 = {username: 'pippo', password: '12345678'}
    @tweet_1 = {body: 'Hello, World!'}
  end

  def teardown
    flushdb
  end

  def test_get_id
    assert_equal 1, get_id
  end

  def test_get_next_id
    assert_equal 1, get_next_id
  end

  def test_highlight
    msg = 'Hello @world from #Australia'
    exp = 'Hello <a href="/tweets/world">@world</a> from <a target="_blank" href="https://en.wikipedia.org/w/index.php?search=Australia">#Australia</a>'
    assert_equal exp, highlight(msg)
  end

  def test_highlight_hashtags
    msg = 'Hello @world from #Australia'
    exp = 'Hello @world from <a target="_blank" href="https://en.wikipedia.org/w/index.php?search=Australia">#Australia</a>'
    assert_equal exp, highlight_hashtags(msg)
  end

  def test_highlight_at
    msg = 'Hello @world from #Australia'
    exp = 'Hello <a href="/tweets/world">@world</a> from #Australia'
    assert_equal exp, highlight_at(msg)
  end

end
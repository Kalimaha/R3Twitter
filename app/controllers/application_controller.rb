class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :initialize_helper

  skip_before_filter :verify_authenticity_token

  def initialize_helper
    init_redis
  end

end
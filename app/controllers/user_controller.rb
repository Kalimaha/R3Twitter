require 'redis'
require 'date'

class UserController < ApplicationController

  include UserHelper

  skip_before_filter :verify_authenticity_token

  def index
  end

  def login
    if valid_login_params?(params)
      if exists?(params[:username])
        @user = get_user(get_user_id(params[:username]))
        redirect_to '/tweets/' + @user['username']
      else
        flash[:error] = "User <i>#{params[:username]}</i> does NOT exists. Please register."
        redirect_to '/'
      end
    else
      flash[:error] = 'Please provide your username and password.'
      redirect_to '/'
    end
  end

  def register
    if valid_registration_params?(params)
      user = Hash.new
      user['username'] = params[:new_username]
      user['password'] = params[:new_password]
      if create_user(user) == 'OK'
        flash[:success] = 'Registration complete, please login.'
        redirect_to '/'
        return
      else
        flash[:error] = 'Registration failed. Please try again.'
        redirect_to '/'
        return
      end
    else
      flash[:error] = 'Please enter an username, a password, and a matching confirmation password.'
      redirect_to '/'
    end
  end

  def create_following
    follow(params[:first_user_id], params[:second_user_id])
    redirect_to '/tweets/' + get_user(params[:first_user_id])['username']
  end

  def list
    ids = @namespaced.hvals('users')
    @users = []
    ids.each {|id| @users << get_user(id)}
    @follower_id = get_user_id(params[:username])
    @users
  end

end
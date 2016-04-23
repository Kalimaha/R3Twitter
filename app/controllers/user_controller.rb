require 'redis'
require 'date'

class UserController < ApplicationController

  include UserHelper

  def index
  end

  def login
    if valid_login_params?(params)
      if exists?(params[:username].downcase)
        @user = get_user(get_user_id(params[:username].downcase))
        redirect_to '/tweets/' + @user['username'].downcase
      else
        flash[:error] = "User <i>#{params[:username].downcase}</i> does NOT exists. Please register."
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
      user['username'] = params[:new_username].downcase
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
    @follower_id = get_user_id(params[:username].downcase)
    @users
  end

end
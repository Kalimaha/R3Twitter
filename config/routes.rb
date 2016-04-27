Rails.application.routes.draw do

  # Root URL
  root 'user#index'

  # Login route
  post '/login', to: 'user#login'

  # Registration rout
  post '/register', to: 'user#register'

  # Timeline
  get '/tweets/:username', to: 'tweet#retrieve'
  get '/tweets/:username/new', to: 'tweet#new'
  post '/create/tweet/:username', to: 'tweet#create'

  # Users
  get '/users/:username', to: 'user#list'
  get '/create_following/:first_user_id/:second_user_id', to: 'user#create_following'

end
Rails.application.routes.draw do

  # Root URL
  root 'user#index'

  # Login route
  post '/login', to: 'user#login'

  # Registration rout
  post '/register', to: 'user#register'

  # Timeline
  get '/tweets/:username', to: 'tweet#retrieve'

end
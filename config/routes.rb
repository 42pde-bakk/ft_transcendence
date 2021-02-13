Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get 'guilds/index'
  # root "home#index"
  root "home#auth"
  get "/home", to: "home#index"
  scope "api" do
    resources :profile
    # friends actions
    resources :friendships
    post '/friendships/add'
    post '/friendships/accept'
    post '/friendships/reject'
    post '/friendships/destroy'
    post '/friendships/get_all'
    post '/friendships/active'
    # guild actions
    resources :guilds
    post '/guilds/join'
    post '/guilds/quit'
    post '/guilds/accept_request'
    post '/guilds/reject_request'
  end
  # map.resources :friendships
end

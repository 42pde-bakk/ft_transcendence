Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get 'guilds/index'
  # root "home#index"
  root "home#auth"
  get "/home", to: "home#index"
  get 'game/index'
  # get "/game", to: "game#index"
  get "/logout", to: "home#logout"
  scope "api" do
    #profile actions
    resources :profile
    post '/profile/changeAccount'
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

    resources :game
    post '/game/join'

    resources :chat
    post '/chat/send'
  end
  # map.resources :friendships
end

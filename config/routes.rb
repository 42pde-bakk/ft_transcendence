Rails.application.routes.draw do
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
    post '/guilds/invite'
    post '/guilds/quit'
    post '/guilds/accept_request'
    post '/guilds/reject_request'
    post '/guilds/accept_invite'
    post '/guilds/reject_invite'
  end
  # map.resources :friendships
end

Rails.application.routes.draw do
  get 'guilds/index'
  # root "home#index"
  root "home#auth"
  get "/home", to: "home#index"
  get "/logout", to: "home#logout"
  scope "api" do
    #profile actions
    resources :profile
    post '/profile/changeAccount'
    post '/profile/index_no_self'
    post '/profile/getAdmin'
    # friends actions
    resources :friendships
    post '/friendships/add'
    post '/friendships/accept'
    post '/friendships/reject'
    post '/friendships/destroy'
    post '/friendships/not_friends'
    # guild actions
    resources :guilds
    post '/guilds/invite'
    post '/guilds/users_available'
    post '/guilds/remove'
    post '/guilds/accept_invite'
    post '/guilds/reject_invite'
  end
  # map.resources :friendships
end

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
    post '/profile/index_not_banned'
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
    # War actions
    resources :wars
    post '/wars/create'
    post '/wars/accept_war'
    post '/wars/reject_war'
    post '/guilds/set_officer'
    post '/guilds/unset_officer'
    # Battle actions
    resources :battles
    post '/battles/create'
    post '/battles/accept_battle'
    post '/battles/reject_battle'
    post '/battles/resolve_battle'
    # admin actions
    resources :admin
    post '/admin/ban'
  end
  # map.resources :friendships
end

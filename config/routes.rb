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
    post '/profile/index_no_self'
    post '/profile/index_not_banned'
    post '/profile/index_not_admin'
    post '/profile/index_admin_only'
    post '/profile/getOwner'
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
    post '/guilds/set_officer'
    post '/guilds/unset_officer'
    # admin actions
    resources :admin
    post '/admin/ban'
    post '/admin/getAdmin'
    post '/admin/removeAdmin'


    resources :game
    post '/game/join'

    resources :chat
    post '/chat/send_dm'
    post '/chat/send_groupmessage'
    post '/chat/block_user'
    post '/chat/unblock_user'
  end
  # map.resources :friendships
end

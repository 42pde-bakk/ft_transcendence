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
    post '/guilds/add_points'
    post '/guilds/update_officer_status'
    # War actions
    resources :wars
    post '/wars/create'
    post '/wars/accept_war'
    post '/wars/reject_war'
    post '/wars/check_if_ended'
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
    post '/admin/getAdmin'
    post '/admin/removeAdmin'

    # tournaments actions
    resources :tournaments
    post '/tournaments/startTournament'
    post '/tournaments/checkAuthTournament'
    post '/tournaments/registerUser'
    post '/tournaments/endTournament'
    post '/tournaments/index_upcoming_tournaments'
    post '/tournaments/index_ongoing_tournaments'
    post '/tournaments/index_tournament_users'
    post '/tournaments/index_tournament_current_game'

    resources :notification
    post '/notification/create_wartime_duel_request'

    resources :game
    post '/game/join'
    post '/game/queue_ladder'
    post '/game/cancel_queue_ladder'

    resources :chatroom
    post '/chat/send_dm'
    post '/chat/send_groupmessage'
    post '/chat/block_user'
    post '/chat/unblock_user'
    post '/chat/unblock_user'
    post '/chatroom/update_admin_status'
  end
  # map.resources :friendships
end

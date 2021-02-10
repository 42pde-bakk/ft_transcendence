Rails.application.routes.draw do
	mount ActionCable.server => '/cable'

  get '/game/:room_number' => 'game#play'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
  end
  # map.resources :friendships
end

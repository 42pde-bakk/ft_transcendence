Rails.application.routes.draw do
  # root "home#index"
  root "home#auth"
  get "/home", to: "home#index"
  scope "api" do
    resources :profile
  end
  # map.resources :friendships
end

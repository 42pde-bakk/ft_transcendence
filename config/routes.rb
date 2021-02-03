Rails.application.routes.draw do
  root "home#index"

  scope "api" do
    resources :profile
  end
end

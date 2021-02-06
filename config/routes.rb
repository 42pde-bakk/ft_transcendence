Rails.application.routes.draw do
  get '/game/:id' => 'game#play'
	root 'game#index'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

	mount ActionCable.server => '/cable'
end

Rails.application.routes.draw do
	mount ActionCable.server => '/cable'


  get '/game/:room_number' => 'game#play'
	root 'game#index'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end

class GameController < ApplicationController
	before_action :set_params

	def index
	end

	def play
		# Kinda useless now, it just sets some @game_id for the controller
		# All the actual rails stuff is happening in game_channel
	end

	def set_params
		@game_id = params[:room_number]
	end
end

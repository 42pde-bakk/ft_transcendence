class GameController < ApplicationController
	before_action :set_params

	def index
	end

	def play
	end

	def set_params
		@game_id = params[:room_number]
	end
end

class GameController < ApplicationController
	before_action :set_params
	skip_before_action :verify_authenticity_token

	def index
	end

	def join
		i = 0
		STDERR.puts("@game_id is #{@game_id}")
		until i > 10 or @game
			@game = Game.find_by(room_nb: @game_id)
			sleep 0.5
			i += 1
		end
		# Do something like @game.build_player1(@user)
	end

	def set_params
		@game_id = params[:room_nb]
		# Set @user to be the current user
	end
end

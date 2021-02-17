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
		if @game.player1 == nil
			@game.assign_attributes(player1: @user)
		elsif @game.player2 == nil
			@game.assign_attributes(player2: @user)
		end
		STDERR.puts("after assigning attributes")
	end

	def set_params
		@game_id = params[:room_nb]
		# Set @user to be the current user
		@user = User.find_by(log_token: params[:authenticity_token])
		if @user then STDERR.puts("@user.log_token is #{@user.log_token}") end
	end
end

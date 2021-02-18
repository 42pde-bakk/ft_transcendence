class GameController < ApplicationController
	before_action :set_params
	skip_before_action :verify_authenticity_token

	def index
	end

	def find_or_create_game
		ant = User.find_by(name: "Ant-Man")
		@game = Game.find_by(room_nb: @game_id)
		if @game
			STDERR.puts("Found game by room_nb: #{@game_id}")
			@game.player2 = @user
		else
			if @user.game then @user.game.destroy end
			@user.create_game(room_nb: @game_id, player2: ant)
			@user.game.mysetup
			saveret = @user.game.save
			STDERR.puts("saveret = #{saveret}")
		end
	end

	def join
		find_or_create_game
		STDERR.puts("@game_id is #{@game_id}, game is #{@user.game}")
	end

	def set_params
		@game_id = params[:room_nb]
		STDERR.puts("in set_params")
		@user = User.find_by(log_token: params[:authenticity_token]) 		# Set @user to be the current user
		if @user then STDERR.puts("@user.log_token is #{@user.log_token}") end
	end
end

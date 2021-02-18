class GameController < ApplicationController
	before_action :set_params
	skip_before_action :verify_authenticity_token

	def index
	end

	def find_or_create_game
		@game = Game.find_by(room_nb: @game_id)
		if @game
			STDERR.puts("Found game by room_nb: #{@game_id}")
		else
			@game = Game.create(room_nb: @game_id)
			STDERR.puts "GAME CREATED, game = #{@game}, game.room_nb is #{@game.room_nb}"
			@game.mysetup
			saveret = @game.save
			STDERR.puts("saveret = #{saveret}")
		end
	end

	def add_player
		if @game
			@game.assign_attributes({ :player1 => @user })
			@game.save
		end
		STDERR.puts("AFTER ADDING PLAYER AS PLAYER 1")
	end

	def join
		find_or_create_game
		add_player
		STDERR.puts("@game_id is #{@game_id}, game is #{@game}")
		STDERR.puts("after assigning attributes, player 1 is #{@game.player1}")
	end

	def set_params
		@game_id = params[:room_nb]
		STDERR.puts("in set_params")
		@user = User.find_by(log_token: params[:authenticity_token]) 		# Set @user to be the current user
		if @user then STDERR.puts("@user.log_token is #{@user.log_token}") end
	end
end

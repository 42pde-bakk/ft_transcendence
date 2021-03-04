class GameController < ApplicationController
	before_action :set_params
	skip_before_action :verify_authenticity_token

	def index
		render json: Game.all, status: :ok
	end

	def show
		game = Game.find(params[:id]) rescue nil
		if game
			render json: game, status: :ok
		else
			render json: { error: "Sorry, couldn't find a game with that id" }, status: :bad_request
		end
	end

	def create
		game = Game.create(player1: @user, name_player1: @user.name, name_player2: "Feskir")
		game.mysetup
		game.save
		@user.save
		GameJob.perform_later(game.id)
		render json: { alert: "Please navigate to your gamepage", page: "#game/#{game.id}" }, status: :ok
		# redirect_to "#game/#{game.id}"
	end

	def create_game(usr1, usr2)
		@game = Game.create(player1: usr1, player2: usr2, name_player1: usr1.name, name_player2: usr2.name)
		@game.save
		@game.mysetup
		@game.save
		GameJob.perform_later(@game)
	end

	# def find_or_create_game
	# 	ant = User.find_by(name: "Ant-Man")
	# 	@game = Game.find_by(room_nb: @game_id)
	# 	if @game
	# 		STDERR.puts("Found game by room_nb: #{@game_id}")
	# 		@game.player2 = @user
	# 	else
	# 		if @user.game then @user.game.destroy end
	# 		@user.create_game(room_nb: @game_id, player2: ant)
	# 		@user.game.mysetup
	# 		@user.game.add_player(@user, 0) # 0 means as left player
	# 		saveret = @user.game.save
	# 		STDERR.puts("saveret = #{saveret}")
	# 	end
	# end

	# def join
	# 	find_or_create_game
	# 	STDERR.puts("@game_id is #{@game_id}, game is #{@user.game}")
	# end

	def set_params
		STDERR.puts("in set_params")
		@user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		# if @user then STDERR.puts("@user.log_token is #{@user.log_token}") end
	end
end

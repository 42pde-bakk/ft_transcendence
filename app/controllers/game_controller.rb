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
		game.save
		GameJob.perform_later(game.id)
		render json: { alert: "Please navigate to your gamepage", page: "#game/#{game.id}" }, status: :ok
	end

	def create_game(usr1, usr2)
		game = Game.create(player1: usr1, player2: usr2, name_player1: usr1.name, name_player2: usr2.name)
		game.save
		GameJob.perform_later(game.id)
	end

	def set_params
		@user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
	end
end

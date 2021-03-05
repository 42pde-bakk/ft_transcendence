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

	def create # Set up a game against a bot
		if Game.find_by(player2: @user) or Game.find_by(player1: @user) then return render json: { error: "Error creating game, you must not already be in a game" }, status: :not_acceptable end
		game = Game.create(player1: @user, name_player1: @user.name, name_player2: "Feskir", gametype: "casual")
		game.mysetup
		game.save

		NotificationChannel.broadcast_to(@user, {
			message: "Game has been set up for you",
			redirection: "#game/#{game.id}"
		})
		render json: { status: "Succesfully created a practice game against the AI" }, status: :ok
	end

	def create_game(usr1, usr2, gametype)
		game = Game.create(player1: usr1, player2: usr2, name_player1: usr1.name, name_player2: usr2.name, gametype: gametype)
		game.mysetup
		game.save

		if usr1
			NotificationChannel.broadcast_to(usr1, {
				message: "Game has been set up for you",
				redirection: "#game/#{game.id}"
			})
		end
		if usr2
			NotificationChannel.broadcast_to(usr2, {
				message: "Game has been set up for you",
				redirection: "#game/#{game.id}"
			})
		end
	end

	def set_params
		@user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
	end
end

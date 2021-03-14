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

	def cancel_queue_ladder
		return render json: { error: "Can't verify user" }, status: :unauthorized unless @user
		@user.update_attribute(:is_queueing, false)
		@user.save
		render json: { status: "Succesfully cancelled queue" }, status: :ok
	end

	def queue_ladder
		return render json: { error: "Can't verify user" }, status: :unauthorized unless @user
		queueing_users = User.where(is_queueing: true).where.not(id: @user.id)
		if queueing_users.length > 0
			opponent = queueing_users.first
			opponent.update_column(:is_queueing, false)
			laddergame = Game.create(player1: opponent, name_player1: opponent.name, player2: @user, name_player2: @user.name, gametype: "ranked")
			laddergame.mysetup
			laddergame.save
			NotificationChannel.broadcast_to(@user, {
				message: "Found you a ladder match, lil gangsta",
				redirection: "#game/#{laddergame.id}"
			})
			NotificationChannel.broadcast_to(opponent, {
				message: "Found you a ladder match, lil gangsta 2",
				redirection: "#game/#{laddergame.id}"
			})
			render json: { status: "Lets go broer" }, status: :ok
		else
			@user.update_attribute(:is_queueing, true)
			@user.save
			render json: { status: "Succesfully queued for ladder, please wait" }, status: :ok
		end
	end

	def create # Set up a game against a bot
		return render json: { error: "Error creating game, you must not already be in a game" }, status: :not_acceptable if Game.find_by(player2: @user, is_finished: false) or Game.find_by(player1: @user, is_finished: false)
		game = Game.create(player1: @user, name_player1: @user.name, name_player2: "Bottt", gametype: "practice")
		game.mysetup
		game.save

		NotificationChannel.broadcast_to(@user, {
			message: "Game has been set up for you",
			redirection: "#game/#{game.id}"
		})
		render json: { status: "Succesfully created a practice game against the AI" }, status: :ok
	end

	def create_game(usr1, usr2, gametype, extra_speed, long_paddles)
		game = Game.create(player1: usr1, player2: usr2, name_player1: usr1.name, name_player2: usr2.name, gametype: gametype, extra_speed: extra_speed, long_paddles: long_paddles)
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

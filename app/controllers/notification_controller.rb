class NotificationController < ApplicationController
	before_action :parse_params
	skip_before_action :verify_authenticity_token

	def parse_params
		puts "In notificationcontroller, params is #{params}"
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		@target_user = User.find(params[:targetuser_id]) rescue nil
		@notification = Notification.find(params[:id]) rescue nil
	end

	def index # Get /api/notification.json
		render json: Notification.where(receiver: @current_user), status: :ok
	end

	def create # Post /api/notification.json
		unless @current_user then return render json: { error: "Can't verify your auth token, sorry bro" }, status: :unauthorized end
		unless @target_user then return render json: { error: "Can't find the user you're trying to send a notification to, sorry bro" }, status: :bad_request end

		if Notification.create(sender: @current_user, receiver: @target_user, is_accepted: false, kind: "gameinvite", name_sender: @current_user.name, name_receiver: @target_user.name).save
			NotificationChannel.broadcast_to(@target_user, {
				message: "new notification bro!"
			})
			render json: { status: "Succesfully sent notificitation to #{@target_user.name}" }, status: :ok
		else
			render json: { error: "Failed to create new notification, sorry bro" }, status: :unprocessable_entity
		end
	end

	def update # Patch/Put /api/notification/:id.json
		# The game invite has been accepted, now to create a new game to matchmake our users into
		unless @current_user then return render json: { error: "Can't verify your auth token, sorry bro" }, status: :unauthorized end
		unless @notification then return render json: { error: "Can't find the notification you're accepting, my man. Did it expire?" }, status: :bad_request end
		if Game.find_by(player2: @current_user) or Game.find_by(player1: @current_user) then return render json: { error: "Error accepting invite, you must not already be in a game" }, status: :not_acceptable end
		if Game.find_by(player2: @target_user) or Game.find_by(player1: @target_user) then return render json: { error: "Error accepting invite, opponent must not already be in a game" }, status: :not_acceptable end

		@notification.is_accepted = true
		@notification.save
		NotificationChannel.broadcast_to(@notification.sender, {
			message: "Your game invite to #{@notification.receiver.name} has been accepted"
		})
		GameController.new.create_game(@notification.sender, @notification.receiver, "casual")
		@notification.destroy
		render json: { status: "Succesfully accepted notification" }, status: :ok
	end

	def destroy # Delete /api/notification/:id.json
		# The game invite has been declined
		unless @current_user then return render json: { error: "Can't verify your auth token, sorry bro" }, status: :unauthorized end
		unless @notification then return render json: { error: "Can't find the notification you're declining, my man. Did it expire?" }, status: :bad_request end

		NotificationChannel.broadcast_to(@notification.sender, {
			message: "Your game invite to #{@notification.receiver.name} has been declined"
		})

		@notification.destroy
		render json: { status: "Succesfully destroyed notification" }, status: :ok
	end
end

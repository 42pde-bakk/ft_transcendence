class NotificationController < ApplicationController
	before_action :parse_params
	skip_before_action :verify_authenticity_token

	def parse_params
		puts "In notificationcontroller, params is #{params}"
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		@target_user = User.find(params[:targetuser_id]) rescue nil
		@notification = Notification.find(params[:id]) rescue nil
		@notification_type = params[:notification_type]
		@game_options = params[:game_options]
		@target_guild = Guild.find(params[:targetguild_id]) rescue nil
	end

	def index # Get /api/notification.json
		render json: Notification.where(receiver: @current_user, is_accepted: false), status: :ok
	end

	def create_wartime_duel_request
		unless @current_user then return render json: { error: "Can't verify your auth token, sorry bro" }, status: :unauthorized end
		unless @target_guild then return render json: { error: "Can't find the guild you're trying to fight" }, status: :bad_request end

			User.where(guild: @target_guild).each do |user|
				notif = Notification.create(sender: @current_user, receiver: user, is_accepted: false, kind: "wartime", name_sender: @current_user.name, name_receiver: user.name)
				if notif.save
					NotificationChannel.broadcast_to(user, {
						message: "new wartime invite!"
					})
				end
				CheckNotificationTimeoutJob.set(wait: @target_guild.active_war.time_to_answer.minutes).perform_later(@current_user, @target_guild)
		end
		render json: { status: "Succesfully sent notifications to each member of #{@target_guild.name}!"}, status: :ok
	end

	def create # Post /api/notification.json
		STDERR.puts("in NotificationController#create, params is #{params}")
		unless @current_user then return render json: { error: "Can't verify your auth token, sorry bro" }, status: :unauthorized end
		unless @target_user then return render json: { error: "Can't find the user you're trying to send a notification to, sorry bro" }, status: :bad_request end
		unless @notification_type then return render json: { error: "Don't understand what type of notification you're trying to create" }, status: :bad_request end
		if @game_options
			extra_speed = @game_options[:extra_speed]
			long_paddles = @game_options[:long_paddles]
		elsif @notification_type == "wartime"
			extra_speed = @current_user.guild&.active_war&.extra_speed
			long_paddles = @current_user.guild&.active_war&.long_paddles
		else
			long_paddles = false
			extra_speed = false
		end

		if Notification.create(sender: @current_user, receiver: @target_user, is_accepted: false, kind: @notification_type, name_sender: @current_user.name, name_receiver: @target_user.name, extra_speed: extra_speed, long_paddles: long_paddles).save
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
		GameController.new.create_game(@notification.sender, @notification.receiver, @notification.kind, @notification.extra_speed, @notification.long_paddles)
		if @notification.kind == "wartime"
			Notification.where(sender: @notification.sender, kind: "wartime", is_accepted: false).destroy_all
		else
			@notification.destroy
		end
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

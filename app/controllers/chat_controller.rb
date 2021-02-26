class ChatController < ApplicationController
	skip_before_action :verify_authenticity_token
	# before_action set_users_please
	def index
	end

	# def find_or_create_chat
	# 	dm_room = PrivateChat.find_by(user1: @current_user, user2: @target_user)
	# 	STDERR.puts("After the first find_by, dm_room is #{dm_room}")
	# 	if dm_room == nil
	# 		dm_room = PrivateChat.find_by(user1: @target_user, user2: @current_user)
	# 		STDERR.puts("And after the second find_by, dm_room is #{dm_room}")
	# 	end
	# 	if dm_room == nil
	# 		dm_room = PrivateChat.create(user1: @current_user, user2: @target_user)
	# 		saveret = dm_room.save
	# 		STDERR.puts("After creating it, dm_room is #{dm_room}, and dmroom saveret is #{saveret}")
	# 	else
	# 		STDERR.puts("found dm_room")
	# 	end
	# 	PrivateChat.puts(dm_room)
	# 	dm_room
	# end

	def block_user
		set_users_please

		if @current_user == nil or @target_user == nil
			puts "Oopsie, something went wrong"
			return false
		end

		if BlockedUser.find_by(user: @current_user, towards: @target_user) != nil
			render json: {alert: "Cant block someone multiple times"}, status: :unprocessable_entity
		else
			newblock = BlockedUser.create(user: @current_user, towards: @target_user)
			respond_to do |format|
				if newblock.save
					format.html { }
					format.json { head :no_content }
				else
					format.html { }
					format.json { render json: newblock.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	def unblock_user
		set_users_please
		if @current_user == nil or @target_user == nil
			puts "Oopsie, something went wrong"
			return false
		end

		block = BlockedUser.find_by(user: @current_user, towards: @target_user)
		if block == nil
			render json: {alert: "Cant unblock someone you haven't blocked"}, status: :unprocessable_entity
		else
			block.destroy
			respond_to do |format|
				format.html { }
				format.json { head :no_content }
			end
		end
	end

	def send_dm
		set_users_please

		if @current_user == nil or @target_user == nil
			puts "Oopsie, something went wrong"
			return false
		end

		@message = PrivateMessage.create(message: params[:chat_message], from: @current_user)
		respond_to do |format|
			if @message.save
				ChatChannel.broadcast_to(@current_user, {
					title: @target_user.id,
					body: @message.str(@current_user)
				})
				ChatChannel.broadcast_to(@target_user, {
					title: @current_user.id,
					body: @message.str(@target_user)
				})
				format.html { }
				format.json { head :no_content }
			else
				puts "saving message failed, not pogchamp"
				format.html { }
				format.json { render json: @message.errors, status: :unprocessable_entity}
			end
		end
	end

	def set_users_please
		STDERR.puts("in ChatController::new, params is #{params} and cookies is #{cookies}")
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		@target_user = User.find_by(id: params[:other_user_id]) rescue nil
		if @target_user != nil and @current_user != nil
			STDERR.puts("current_user is #{@current_user.name}, target_user is #{@target_user.name}")
		end

	end
end

class ChatController < ApplicationController
	skip_before_action :verify_authenticity_token
	# before_action set_users_please
	def index
	end

	def find_or_create_chat
		dm_room = PrivateChat.find_by(user1: @current_user, user2: @target_user)
		STDERR.puts("After the first find_by, dm_room is #{dm_room}")
		if dm_room == nil
			dm_room = PrivateChat.find_by(user1: @target_user, user2: @current_user)
			STDERR.puts("And after the second find_by, dm_room is #{dm_room}")
		end
		if dm_room == nil
			dm_room = PrivateChat.create(user1: @current_user, user2: @target_user)
			saveret = dm_room.save
			STDERR.puts("After creating it, dm_room is #{dm_room}, and dmroom saveret is #{saveret}")
		else
			STDERR.puts("found dm_room")
		end
		PrivateChat.puts(dm_room)
		dm_room
	end

	def get_old_messages
		set_users_please
		dm_room = find_or_create_chat

		dm_room.private_messages.each do |msg|
			puts("old message is #{msg.str}")
			ChatChannel.broadcast_to(@current_user, msg.str)
		end
	end

	def send_a_msg
		set_users_please
		dm_room = find_or_create_chat

		@message = PrivateMessage.create(message: params[:chat_message], from: @current_user, private_chat: dm_room)
		STDERR.puts("saving message returned #{@message.save}")
		STDERR.puts("dm_room.save returns #{dm_room.save} ")
		# STDERR.puts("saving a new channel returned #{msg_save_ret}")
		dm_room.private_messages.each do |m|
			STDERR.puts("dm_room has the following message: '#{m.message}'")
		end

		ChatChannel.broadcast_to(@current_user, params[:chat_message])
		ChatChannel.broadcast_to(@target_user, params[:chat_message])
		# respond_to do |format|
		# 	ActionCable.server.broadcast "chat_channel", type: "chat_message", description: "create-message", user: current_user
		# 	format.html { redirect_to @chat_message, notice: 'Room message was succesfully created' }
		# 	format.json { head :no_content}
		# end
	end

	def set_users_please
		STDERR.puts("in ChatController::new, params is #{params} and cookies is #{cookies}")
		@current_user = User.find_by(log_token: cookies[:log_token])
		@target_user = User.find_by(id: params[:other_user_id])

	end
end

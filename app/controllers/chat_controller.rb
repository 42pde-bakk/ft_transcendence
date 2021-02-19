class ChatController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
	end

	def send_a_msg
		STDERR.puts("in ChatController::new, params is #{params} and cookies is #{cookies}")
		current_user = User.find_by(log_token: cookies[:log_token])
		#	current_user = User.find_by(log_token: params[:authenticity_token]) 		# Set @user to be the current user
		target_user = User.find_by(id: params[:other_user_id])
		# STDERR.puts("params is #{params}")
		dm_room = PrivateChat.where(user1: current_user, user2: target_user).or(PrivateChat.where(user1: target_user, user2: current_user))
		if dm_room == nil
			dm_room = PrivateChat.create(user1: current_user, user2: target_user)
			saveret = dm_room.save
			STDERR.puts("created new privatechat, saveret is #{saveret}")
		else
			STDERR.puts("found dm_room")
		end

		@message = PrivateMessage.create(message: params[:chat_message], from: current_user, private_chat: dm_room)
		msg_save_ret = @message.save
		STDERR.puts("saving a new channel returned #{msg_save_ret}")

		ChatChannel.broadcast_to(current_user, params[:chat_message])
		ChatChannel.broadcast_to(target_user, params[:chat_message])
		# respond_to do |format|
		# 	ActionCable.server.broadcast "chat_channel", type: "chat_message", description: "create-message", user: current_user
		# 	format.html { redirect_to @chat_message, notice: 'Room message was succesfully created' }
		# 	format.json { head :no_content}
		# end
	end
end

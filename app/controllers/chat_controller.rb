class ChatController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
	end

	def send_a_msg
#		STDERR.puts("in ChatController::new, params is #{params} and cookies is #{cookies}")
        current_user = User.find_by(log_token: cookies[:log_token])
          #	current_user = User.find_by(log_token: params[:authenticity_token]) 		# Set @user to be the current user
		target_user = User.find_by(id: params[:other_user_id])
		# STDERR.puts("params is #{params}")

		ChatChannel.broadcast_to(current_user, params[:chat_message])
		ChatChannel.broadcast_to(target_user, params[:chat_message])
		# respond_to do |format|
		# 	ActionCable.server.broadcast "chat_channel", type: "chat_message", description: "create-message", user: current_user
		# 	format.html { redirect_to @chat_message, notice: 'Room message was succesfully created' }
		# 	format.json { head :no_content}
		# end
	end
end

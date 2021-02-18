class ChatController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
	end

	def new
		STDERR.puts("in ChatController::new, params is #{params}")
		current_user = User.find_by(log_token: params[:authenticity_token]) 		# Set @user to be the current user
		target_user = User.find_by(id: params[:other_user_id])
		# STDERR.puts("params is #{params}")
		chatroom = Chatroom.find_by(user1: current_user, user2: target_user)
		unless chatroom
			chatroom = Chatroom.find_by(user1: target_user, user2: current_user)
		end
		unless chatroom
			chatroom = Chatroom.create(user1: current_user, user2: target_user)
		end
		@chat_message = "test"
		respond_to do |format|
			ActionCable.server.broadcast "chat_channel", type: "chat_message", description: "create-message", user: current_user
			format.html { redirect_to @chat_message, notice: 'Room message was succesfully created' }
			format.json { head :no_content}
		end
	end

end

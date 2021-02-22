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
			ChatChannel.broadcast_to(@current_user, {
				title: @target_user.id,
				body: msg.str
			})
		end
		respond_to do |format|
			format.html { }
			format.json { head :no_content }
		end
	end

	def send_a_msg
		set_users_please
		dm_room = find_or_create_chat

		@message = PrivateMessage.create(message: params[:chat_message], from: @current_user, private_chat: dm_room)
		respond_to do |format|
			if @message.save
				# ChatChannel.broadcast_to(@current_user, @message.str)
				ChatChannel.broadcast_to(@current_user, {
					title: @target_user.id,
					body: @message.str
				})
				ChatChannel.broadcast_to(@target_user, {
					title: @current_user.id,
					body: @message.str
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
		@current_user = User.find_by(log_token: cookies[:log_token])
		@target_user = User.find_by(id: params[:other_user_id])
		STDERR.puts("current_user is #{@current_user.str}, target_user is #{@target_user.str}")

	end
end

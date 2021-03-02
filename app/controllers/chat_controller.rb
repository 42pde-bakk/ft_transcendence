class ChatController < ApplicationController
	before_action :set_users_please
	skip_before_action :verify_authenticity_token

	def block_user
		if @current_user == nil or @target_user == nil
			puts "Oopsie, something went wrong"
			return false
		end

		if @current_user.blocked_users.find_by(towards: @target_user) != nil
			render json: {alert: "Cant block someone multiple times"}, status: :unprocessable_entity
		else
			newblock = BlockedUser.create(user: @current_user, towards: @target_user)
			if newblock.save
				render json: { status: "Succesfully blocked #{@target_user.name}" }, status: :ok
			else
				render json: { alert: "Error saving new BlockedUser" }, status: :unprocessable_entity
			end
		end
	end

	def unblock_user
		if @current_user == nil or @target_user == nil
			puts "Oopsie, something went wrong"
			return false
		end
		block = @current_user.blocked_users.find_by(towards: @target_user)
		if block == nil
			render json: { alert: "Cant unblock someone you haven't blocked"}, status: :unprocessable_entity
		else
			block.destroy
			render json: { status: "Succesfully unblocked #{@target_user.name}" }, status: :ok
		end
	end

	private
	def handle_password_command(arr)
		if arr[1] == "set"
			if arr[2] == nil or arr[2].empty?
				render json: { error: "If you want to remove the password, please type '/password remove'"}, status: :bad_request
				return
			else
				@groupchat.is_private = true
				@groupchat.password = Base64.strict_encode64(arr[2])
				@groupchat.save
				render json: { status: "Succesfully set new channel password" }, status: :created
			end
		elsif arr[1] == "remove"
			@groupchat.is_private = false
			@groupchat.password = nil
			@groupchat.save
			render json: { status: "Succesfully removed channel password" }, status: :ok
		end
	end

	def handle_admin_command(arr)
	end

	def handle_ban_mute_kick_command(arr)
		if arr[1] == nil or arr[1].empty? or ChatroomMember.find_by(chatroom: @groupchat, user: User.find_by(name: arr[1])) == nil
			render json: { error: "Please supply a valid name to #{arr[0][1..]}" }
		end
		if arr[0] == "/kick"
			ChatroomMember.find_by(chatroom: @groupchat, user: User.find_by(name: arr[1])).destroy
		end

	end

	def handle_commands(msg)
		arr = msg.split
		puts "Array is #{arr}"
		if arr[0] == "/password"
			handle_password_command(arr)
		elsif arr[0] == "/admin"
			return handle_admin_command(arr)
		elsif arr[0] == "/ban" or arr[0] == "/mute" or arr[0] == "/kick"
			handle_ban_mute_kick_command(arr)
		end
	end

	def invalid_message
		render json: { error: "Please send a valid message." }, status: :not_acceptable
	end

	public

	def send_groupmessage
		if @current_user == nil or @groupchat == nil
			if @current_user == nil then puts "Oopsie, something went wrong" else puts "Sorry, that groupchat doesn't exist" end
			return false
		end
		if ChatroomMember.find_by(chatroom: @groupchat, user: @current_user) == nil
			puts "Sorry, but you're not subscribed to this chatroom, it would seem"
			return false
		end
		if @raw_message == nil or @raw_message.empty?
			return invalid_message
		end
		if @raw_message[0] == '/'
			return handle_commands(msg)
		end
		@message = Message.create(msg: @raw_message, user: @current_user, chatroom: @groupchat) # Maybe add the channel as optional here too?

		groupchat_members = ChatroomMember.where(chatroom: @groupchat)
		ChatChannel.broadcast_to(@current_user, {
				title: "groupchat_#{@groupchat.id}",
				body: @message.str(@current_user)
		})
		if @message.save
			groupchat_members.each do |member|
				puts "title: groupchat_#{@groupchat.id}"
				puts "body: #{@message.str(member)}"
				ChatChannel.broadcast_to(member.user, {
					title: "groupchat_#{@groupchat.id}",
					body: @message.str(member.user)
				})
			end
			render json: { status: "Ok" }, status: :ok
		else
			render json: { error: "couldnt save message" }, status: :bad_request
		end
	end

	def send_dm
		if @current_user == nil or @target_user == nil
			puts "Oopsie, something went wrong"
			return false
		end
		if @raw_message == nil or @raw_message.empty?
			return invalid_message
		end
		@message = Message.create(msg: @raw_message, user: @current_user)
		if @message.save
			ChatChannel.broadcast_to(@current_user, {
				title: "dm_#{@target_user.id}",
				body: @message.str(@current_user)
			})
			ChatChannel.broadcast_to(@target_user, {
				title: "dm_#{@current_user.id}",
				body: @message.str(@target_user)
			})
			render json: { status: "Succesfully sent message to dm" }, status: :ok
		else
			puts "saving message failed, not pogchamp"
			render json: { error: "Error saving message, not pogchamp" }, status: :unprocessable_entity
		end
	end

	def set_users_please
		STDERR.puts("in ChatController::new, params is #{params} and cookies is #{cookies}")
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		if params[:action] == "send_groupmessage"
			@groupchat = Chatroom.find(params[:chatroom_id])
		else
			@target_user = User.find_by(id: params[:other_user_id]) rescue nil
		end
		if params[:action].include?("send_")
			@raw_message = params[:chat_message]
		end
	end
end

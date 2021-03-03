class ChatController < ApplicationController
	before_action :set_users_please
	skip_before_action :verify_authenticity_token

	def block_user
		if @current_user == nil or @target_user == nil
			return render json: { error: "Couldnt find targets" }, status: :bad_request
		end
		if @current_user.blocked_users.find_by(towards: @target_user) != nil
			render json: { error: "Cant block someone multiple times" }, status: :bad_request
		else
			if BlockedUser.create(user: @current_user, towards: @target_user).save
				render json: { status: "Succesfully blocked #{@target_user.name}" }, status: :ok
			else
				render json: { error: "Error saving new BlockedUser" }, status: :unprocessable_entity
			end
		end
	end

	def unblock_user
		if @current_user == nil or @target_user == nil
			render json: { error: "Couldnt find targets" }, status: :bad_request
			return false
		end
		block = @current_user.blocked_users.find_by(towards: @target_user)
		if block == nil
			render json: { error: "Cant unblock someone you haven't blocked"} , status: :bad_request
		else
			block.destroy
			render json: { status: "Succesfully unblocked #{@target_user.name}" }, status: :ok
		end
	end

	private
	def handle_password_command(arr)
		if @groupchat.owner == @current_user
			if arr[1] == "set"
				if arr[2] == nil or arr[2].empty?
					render json: { error: "If you want to remove the password, please type '/password remove'" }, status: :bad_request
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
		else
			render json: { status: "Sorry buddy, only the channel owner is allowed to set/change/remove the password" }, status: :bad_request
		end
	end

	def handle_admin_command(arr)
		if @groupchat.owner == @current_user
			target_user = User.find_by(name: arr[1])
			unless target_user
				render json: { error: "Can't find a User by the name of #{arr[1]}, please doublecheck, maybe they changed their name?" }, status: :bad_request
				return
			end
			if arr[1] == "new"
				if @groupchat.admins.find_by(user: target_user)
					render json: { error: "What are you doing? #{target_user.name} already is an admin." }, status: :bad_request
				else
					ChatroomAdmin.create(chatroom: @groupchat, user: target_user).save
					render json: { status: "Succesfully made #{target_user.name} an admin of this channel!" }, status: :ok
				end
			elsif arr[1] == "remove"
				if @groupchat.admins.find_by(user: target_user)
					@groupchat.admins.find_by(user: target_user)&.destroy
					render json: { status: "Succesfully stripped #{target_user.name} of their admin role" }, status: :ok
				else
					render json: { error: "What are you doing? #{target_user.name} is not an admin, how are you finna strip him of his role then?" }, status: :bad_request
				end
			end
		else
			render json: { error: "Sure you have the correct permissions for this shit bruh?" }, status: :bad_request
		end
	end

	def handle_ban_mute_kick_command(arr)
		target_user = User.find_by(name: arr[1])
		if arr[1] == nil or arr[1].empty? or target_user == nil or (ChatroomMember.find_by(chatroom: @groupchat, user: target_user) == nil and !arr[0].include?("/un"))
			return render json: { error: "Please supply a valid name to #{arr[0][1..]}" }, status: :bad_request
		end
		if @groupchat.owner == @current_user or (@groupchat.admins.find_by(user: @current_user) and @groupchat.admins.find_by(user: target_user) == nil)
			# Admins can't mute/ban/kick other admins or the owner, but the owner can kick/ban/mute the admins
			if arr[0] == "/kick"
				ChatroomMember.find_by(chatroom: @groupchat, user: target_user)&.destroy
				@groupchat.amount_members -= 1
				@groupchat.save
				render json: { status: "Succesfully kicked #{arr[1]}, good riddance." }, status: :ok
			elsif arr[0] == "/ban"
				ChatroomBan.create(chatroom: @groupchat, user: target_user).save
				ChatroomMember.find_by(chatroom: @groupchat, user: target_user)&.destroy
				@groupchat.amount_members -= 1
				@groupchat.save
				render json: { status: "Succesfully banned #{target_user.name}, fuck that guy" }, status: :ok
			elsif arr[0] == "/unban"
				ChatroomBan.find_by(chatroom: @groupchat, user: target_user)&.destroy
				render json: { status: "You've succesfully unbanne #{target_user.name}, you're a merciful god." }, status: :ok
			elsif arr[0] == "/mute"
				ChatroomMute.create(chatroom: @groupchat, user: target_user).save
				render json: { status: "Succesfully muted #{target_user.name}, they really need to stfu!" }, status: :ok
			elsif arr[0] == "/unmute"
				ChatroomMute.find_by(chatroom: @groupchat, user: target_user)&.destroy
				render json: { status: "Little Johnny #{target_user.name} got his voice back! (Godling)"}, status: :ok
			end
		else
			render json: { error: "Sure you have the correct permissions for this shit bruh?" }, status: :bad_request
		end
	end

	def handle_commands
		arr = @raw_message.split
		puts "Array is #{arr}"
		if arr[0] == "/password"
			handle_password_command(arr)
		elsif arr[0] == "/admin"
			return handle_admin_command(arr)
		elsif arr[0] == "/ban" or arr[0] == "/mute" or arr[0] == "/kick"
			handle_ban_mute_kick_command(arr)
		elsif arr[0] == "/help"
			render json: { error: "The channel owner and channel admins can perform a number of commands:
/password set [newpassword]
/password remove
/ban [username]
/unban [username]
/mute [username]
/unmute [username]
/kick [username]
The channel owner can appoint or remove admins by doing:
/admin new [username]
/admin remove [username]" }, status: :bad_request
		else
			render json: { error: "Command not recognized." }, status: :bad_request
		end
	end

	def invalid_message
		render json: { error: "Please send a valid message." }, status: :not_acceptable
	end

	public

	def send_groupmessage
		puts "INNNNN send_groupmessage, params is #{params}"
		unless @current_user and @groupchat
			if @groupchat
				return render json: { error: "Cannot find current user" }, status: :internal_server_error
			else
				return render json: { error: "Cannot find groupchat" }, status: :internal_server_error
			end
		end
		if @groupchat.members.find_by(user: @current_user) == nil
			return render json: { error: "Sorry, but you're not subscribed to this chatroom, it would seem" }, status: :bad_request
		end
		if @raw_message == nil or @raw_message.empty?
			return invalid_message
		end
		if @raw_message[0] == '/'
			return handle_commands
		end
		@message = Message.create(msg: @raw_message, user: @current_user, chatroom: @groupchat) # Maybe add the channel as optional here too?

		# groupchat_members = ChatroomMember.where(chatroom: @groupchat)
		# ChatChannel.broadcast_to(@current_user, {
		# 		title: "groupchat_#{@groupchat.id}",
		# 		body: @message.str(@current_user)
		# })
		if @message.save
			@groupchat.members.each do |member|
				ChatChannel.broadcast_to(member.user, {
					title: "groupchat_#{@groupchat.id}",
					msg_id: @message.id,
					body: @message.str(member.user)
				})
			end
			render json: { status: "Succesfully sent groupchat message" }, status: :ok
		else
			render json: { error: "Error, couldn't save your groupchat message" }, status: :bad_request
		end
	end

	def send_dm
		unless @current_user and @target_user
			return render json: { error: "Cannot find current user" }, status: :internal_server_error
		end
		if @raw_message == nil or @raw_message.empty?
			return invalid_message
		end
		@message = Message.create(msg: @raw_message, user: @current_user)
		if @message.save
			ChatChannel.broadcast_to(@current_user, {
				title: "dm_#{@target_user.id}",
				msg_id: @message.id,
				body: @message.str(@current_user)
			})
			ChatChannel.broadcast_to(@target_user, {
				title: "dm_#{@current_user.id}",
				msg_id: @message.id,
				body: @message.str(@target_user)
			})
			render json: { status: "Succesfully sent message to dm" }, status: :ok
		else
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

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
			respond_to do |format|
				ChatChannel.broadcast_to(@current_user, {
					title: @target_user.id,
					body: "Dude, you can't just block #{@target_user.name} twice...\nNot cool dude."
				})
				format.html { }
				format.json { head :no_content }
			end
		else
			newblock = BlockedUser.create(user: @current_user, towards: @target_user)
			respond_to do |format|
				if newblock.save
					ChatChannel.broadcast_to(@current_user, {
						title: @target_user.id,
						body: "#{@target_user.name} has succesfully been blocked"
					})
					format.html { }
					format.json { head :no_content }
				else
					ChatChannel.broadcast_to(@current_user, {
						title: @target_user.id,
						body: "Fuck, something went wrong in blocking #{@target_user.name}"
					})
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

		respond_to do |format|
			if block != nil and block.destroy
				ChatChannel.broadcast_to(@current_user, {
					title: @target_user.id,
					body: "#{@target_user.name} has succesfully been unblocked"
				})
				format.html { }
				format.json { head :no_content }
			else
				ChatChannel.broadcast_to(@current_user, {
					title: @target_user.id,
					body: "Yo, are you sure you blocked #{@target_user.name}?"
				})
				format.html { }
				format.json { render json: newblock.errors, status: :unprocessable_entity }
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
		saveret = @message.save
		STDERR.puts "moetherukdlsfjlsdjf, saveret is #{saveret}, message is #{@message}"
		respond_to do |format|
			if @message.save
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
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		@target_user = User.find_by(id: params[:other_user_id]) rescue nil
		if @target_user != nil and @current_user != nil
			STDERR.puts("current_user is #{@current_user.str}, target_user is #{@target_user.str}")
		end

	end
end

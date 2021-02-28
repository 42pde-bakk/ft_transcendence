class ChatController < ApplicationController
	# before_action set_users_please
	skip_before_action :verify_authenticity_token

	def groupchat_before
		STDERR.puts("in groupchat_before, params is #{params} and cookies is #{cookies}")
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
	end

	def index # responds to jQuery.get("/api/chat")
		puts "in chat_controller#index"
		respond_to do |format|
			# format.html { }
			format.html { redirect_to "/", notice: '^^' }
			format.json { render json: Chatroom.all, status: :ok }
		end
	end

	def create # responds to jQuery.post("/api/chat")
		groupchat_before
		puts "in chatcontroller, create"
		name = params[:groupchat_name]
		password = params[:groupchat_password]
		if Chatroom.find_by(name: name)
			render json: { error: "This groupchat name has already been taken"}, status: :conflict
		else
			if password == nil
				myChatroom = Chatroom.create(name: name, owner: @current_user, isprivate: false)
			else
				myChatroom = Chatroom.create(name: name, owner: @current_user, isprivate: true, password: password)
			end
			if myChatroom.save #success
				puts " saving chatroom was a success!"
				respond_to do |format|
					format.html { }
					format.json { head :no_content }
				end
			else
				respond_to do |format|
					format.html { }
					format.json { head :no_content }
				end
			end
		end
	end

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

		@message = Message.create(msg: params[:chat_message], from: @current_user)
		respond_to do |format|
			if @message.save
				ChatChannel.broadcast_to(@current_user, {
					title: "dm_#{@target_user.id}",
					body: @message.str(@current_user)
				})
				ChatChannel.broadcast_to(@target_user, {
					title: "dm_#{@current_user.id}",
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

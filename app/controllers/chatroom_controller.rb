class ChatroomController < ApplicationController
	before_action :parse_params
	before_action :param_update_actiontype, only: [:update]
	before_action :param_chatroom_name, only: [:create]
	before_action :param_chatroom_pw, only: [:create, :update]
	before_action :param_chatroom_by_id, only: [:update, :destroy]
	skip_before_action :verify_authenticity_token

	def parse_params
		puts "In parse_params, params is #{params}"
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
	end
	def param_chatroom_by_id
		@chatroom = Chatroom.find(params[:id]) rescue nil
	end
	def param_chatroom_pw
		@chatroom_pw = params[:chatroom_password]
	end
	def param_chatroom_name
		@chatroom_name = params[:chatroom_name]
	end
	def param_update_actiontype
		@update_actiontype = params[:update_action]
	end

	def index # responds to a GET request on "/chatroom"
		render json: Chatroom.all_with_subscription_status(@current_user), status: :ok
	end

	def show # responds to a GET request on "/api/chatroom/:id"
		render json: Chatroom.find(params[:id]), status: :ok
	end

	def update # responds to a PATCH/PUT request to "/api/chatroom/:id"
		STDERR.puts "update_actiontype is #{@update_actiontype}"
		return render json: { error: "Cannot find current user" }, status: :internal_server_error unless @current_user
		if @update_actiontype == "give_admin" or @update_actiontype == "remove_admin"
			target_user = User.find_by(name: params[:targetuser_name])
			return render json: { error: "Error finding the user by the name of #{params[:targetuser_name]}"}, status: :bad_request unless target_user
			return give_admin_status(target_user) if @update_actiontype == "give_admin"
			return remove_admin_status(target_user)
		end
		return join_chatroom if @update_actiontype == "join"
		leave_chatroom
	end

	def join_chatroom
		return render json: { error: "Error finding the specified chatroom." }, status: :bad_request unless @chatroom
		if @chatroom.members.find_by(user: @current_user) == nil #This user is not yet subscribed to this channel
			return render json: { error: "You're not allowed to join this channel, as you've been banned." }, status: :unauthorized if @chatroom.bans.find_by(user: @current_user)
			if @chatroom.is_private
				return render json: { error: "Error. Bad password given." }, status: :unauthorized if @chatroom.password != Base64.strict_encode64(@chatroom_pw)
			end
			newmember = ChatroomMember.create(chatroom: @chatroom, user: @current_user)
			if newmember.save
				@chatroom.amount_members += 1
				@chatroom.save
				@chatroom.members.each do |m|
					if m != newmember
						ChatChannel.broadcast_to(m.user, {
							title: "groupchat_#{@chatroom.id}",
							body: " - #{newmember.user.name} has joined the channel!"
						})
					end
				end
				render json: { status: "Succesfully joined chatchannel #{@chatroom.name}" }, status: :ok
			else
				render json: { error: "Saving new chatroom member failed, sorry" }, status: :unprocessable_entity
			end
		else
			render json: { status: "You've already joined this channel" }, status: :no_content
		end
	end

	def leave_chatroom # responds to a DELETE request to "/api/chatroom/:id"
		return render json: { error: "Error finding the specified chatroom." }, status: :bad_request unless @chatroom
		if @chatroom.owner == @current_user
			@chatroom.destroy
			return render json: { status: "Owner left the channel, therefore we disband it" }, status: :ok
		end
		myChatroomMember = @chatroom.members.find_by(user: @current_user)
		if myChatroomMember != nil
			myChatroomMember.destroy
			@chatroom.amount_members -= 1
			@chatroom.save
			render json: { status: "Nice" }, status: :ok
		else
			render json: { error: "Cant leave a channel you've not joined" }, status: :bad_request
		end
	end

	def destroy # responds to a DELETE request on "/api/chatroom/:id"
		return render json: { error: "Cannot find current user" }, status: :unauthorized unless @current_user
		if @current_user.owner or @current_user.admin
			return render json: { error: "Error finding the specified chatroom." }, status: :bad_request unless @chatroom
			chatroom_name = @chatroom.name
			@chatroom.destroy
			return render json: { status: "Succesfully destroyed chatroom #{chatroom_name}!" }, status: :ok
		end
		render json: { error: "Only server owner/admins can destroy chatchannels." }, status: :unauthorized
	end

	def create # responds to a POST request on "/api/chatroom"
		unless @current_user
			return render json: { error: "Cannot find current user" }, status: :internal_server_error
		end
		if @chatroom_name == nil or @chatroom_name.empty?
			render json: { error: "You need to specify a valid name" }, status: :bad_request
			return
		end
		if Chatroom.find_by(name: @chatroom_name)
			render json: { error: "This groupchat name has already been taken"}, status: :conflict
		else
			if @chatroom_pw.empty?
				myChatroom = Chatroom.create(name: @chatroom_name, owner: @current_user, is_private: false, amount_members: 1)
			else
				puts "password is #{@chatroom_pw}, encrypted it is #{Base64.strict_encode64(@chatroom_pw)}"
				myChatroom = Chatroom.create(name: @chatroom_name, owner: @current_user, is_private: true, password: Base64.strict_encode64(@chatroom_pw), amount_members: 1)
			end
			if myChatroom.save #success
				newMember = ChatroomMember.create(chatroom: myChatroom, user: @current_user)
				newMember.save
				render json: { status: "Succesfully created groupchat", id: myChatroom.id }, status: :ok
			else
				render json: { error: "error saving chatroom" }, status: :internal_server_error
			end
		end
	end

	def give_admin_status(target_user)
		return render json: { error: "Error. #{target_user.name} is already an admin of this channel." }, status: :bad_request if ChatroomAdmin.find_by(chatroom: @chatroom, user: target_user)
		newadmin = ChatroomAdmin.create(chatroom: @chatroom, user: target_user)
		return render json: { alert: "Succesfully made #{target_user.name} an admin of channel #{@chatroom.name}!" }, status: :ok if newadmin.save
		render json: { error: "Error creating chatroomadmin." }, status: :internal_server_error
	end

	def remove_admin_status(target_user)
		byebyeadmin = ChatroomAdmin.find_by(chatroom: @chatroom, user: target_user)
		return render json: { error: "Error. #{target_user.name} isn't an admin of this channel." }, status: :bad_request unless byebyeadmin
		byebyeadmin.destroy
		render json: { alert: "Succesfully removed #{target_user.name} of their admin status of channel #{@chatroom.name}!" }, status: :ok
	end
end

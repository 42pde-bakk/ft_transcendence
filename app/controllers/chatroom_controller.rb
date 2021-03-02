class ChatroomController < ApplicationController
	before_action :parse_params
	skip_before_action :verify_authenticity_token

	def parse_params
		puts "In parse_params, params is #{params}"
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		if params[:action] == "index" then return end

		@chatroom_name = params[:chatroom_name]
		@chatroom_pw = params[:chatroom_password]
		if params[:action] != "create"
			@chatroom = Chatroom.find(params[:id])
		end
	end

	def index # responds to a GET request on "/chatroom"
			render json: Chatroom.all_with_subscription_status(@current_user), status: :ok
	end

	def update # responds to a PATCH/PUT request to "/api/chatroom/:id"
		if ChatroomMember.find_by(chatroom: @chatroom, user: @current_user) == nil #This user is not yet subscribed to this channel
			if @chatroom.is_private
				puts "password is #{@chatroom_pw}, encrypted it is #{Base64.strict_encode64(@chatroom_pw)}"

				if @chatroom.password != Base64.strict_encode64(@chatroom_pw)
					render json: {error: "Wrong password" }, status: :unauthorized
					return false
				end
			end
			newmember = ChatroomMember.create(chatroom: @chatroom, user: @current_user)
			if newmember.save
				@chatroom.amount_members += 1
				@chatroom.save
				 ChatroomMember.where(chatroom: @chatroom).each do |m|
					 if m != newmember
						 ChatChannel.broadcast_to(m.user, {
							 title: "groupchat_#{@chatroom.id}",
							 body: " - #{newmember.user.name} has joined the channel!"
						 })
					 end
				 end
			end
		end
		respond_to do |format|
			format.html { }
			format.json { head :no_content}
		end
	end

	def destroy # responds to a DELETE request to "/api/chatroom/:id"
		puts "in chatroom_controller#destroy"
		myChatroomMember = ChatroomMember.find_by(chatroom: @chatroom, user: @current_user)
		if myChatroomMember != nil
			myChatroomMember.destroy
			@chatroom.amount_members -= 1
			@chatroom.save
			render json: {status: "Nice" }, status: :ok
		else
			render json: {error: "Cant leave a channel you've not joined" }, status: :bad_request
		end
	end

	def show # responds to a GET request on "/api/chatroom/:id"
		puts "in chatroom_controller#show"
	end

	def create # responds to a POST request on "/api/chatroom"
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

end

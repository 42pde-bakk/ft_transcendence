class ChatroomController < ApplicationController
	before_action :parse_params
	skip_before_action :verify_authenticity_token

	def parse_params
		puts "In parse_params, params is #{params}"
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		if params[:action] == "index" then return end

		@chatroom = Chatroom.find(params[:id])
		@chatroom_pw = params[:chatroom_password]
		@chatroom_name = params[:chatroom_name]
	end

	def index # responds to a GET request on "/chatroom"
		respond_to do |format|
			format.html { redirect_to "/", notice: '^^' } #idk man, i just copied this and im leaving it in, I dont think this route will ever be called with a html format
			format.json { render json: Chatroom.all_with_subscription_status(@current_user), status: :ok }
		end
	end

	def update # responds to a PATCH/PUT request to "/api/chatroom/:id"
		if ChatroomMember.find_by(chatroom: @chatroom, user: @current_user) == nil #This user is not yet subscribed to this channel
			if @chatroom.is_private
				puts "password is #{@chatroom_pw}, encrypted it is #{Base64.strict_encode64(@chatroom_pw)}"

				if @chatroom.password != Base64.strict_encode64(@chatroom_pw)
					render json: {error: "Wrong password" }, status: :conflict
					return false
				end
			end
			newmember = ChatroomMember.create(chatroom: @chatroom, user: @current_user)
			if newmember.save
				@chatroom.amount_members += 1
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
			render json: {status: "Nice" }, status: :ok
		else
			render json: {error: "Cant leave a channel you've not joined" }, status: :conflict
		end
	end

	def show # responds to a GET request on "/api/chatroom/:id"
		puts "in chatroom_controller#show"
	end

	def create # responds to a POST request on "/api/chatroom"
		if Chatroom.find_by(name: @chatroom_name)
			render json: { error: "This groupchat name has already been taken"}, status: :conflict
		else
			if @chatroom_pw == nil
				myChatroom = Chatroom.create(name: name, owner: @current_user, isprivate: false)
			else
				puts "password is #{@chatroom_pw}, encrypted it is #{Base64.strict_encode64(@chatroom_pw)}"
				myChatroom = Chatroom.create(name: name, owner: @current_user, isprivate: true, password: Base64.strict_encode64(@chatroom_pw))
			end
			if myChatroom.save #success
				newMember = ChatroomMember.create(chatroom: myChatroom, user: @current_user)
				newMember.save
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

end

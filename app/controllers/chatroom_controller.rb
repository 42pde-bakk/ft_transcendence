class ChatroomController < ApplicationController
	# before_action parse_params
	skip_before_action :verify_authenticity_token

	def parse_params
		puts "In parse_params, params is #{params}"
		@current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
		if params[:action] == "index"
			return
		end
		@chatroom = Chatroom.find(params[:id])
		@chatroom_pw = params[:chatroom_password]
		@chatroom_name = params[:chatroom_name]
	end

	def index # responds to a GET request on "/chatroom"
		puts "in chatroom_controller#index"
		parse_params
		respond_to do |format|
			# format.html { }
			format.html { redirect_to "/", notice: '^^' }
			format.json { render json: Chatroom.all_with_subscription_status(@current_user), status: :ok }
		end
	end

	def update # responds to a PATCH/PUT request to "/api/chatroom/:id"
		puts "in chatroom_controller#update"
		parse_params
		if ChatroomMember.find_by(chatroom: @chatroom, user: @current_user) == nil #This user is not yet subscribed to this channel
			if @chatroom.is_private
				puts "@chatroom (#{@chatroom.name}) => is_private = #{@chatroom.is_private}"
				if @chatroom.password != @chatroom_pw
					puts "Wrong password!"
					render json: {error: "Wrong password" }, status: :conflict
					return false
				end
			end
			newmember = ChatroomMember.create(chatroom: @chatroom, user: @current_user)
			if newmember.save
				 ChatroomMember.where(chatroom: @chatroom).each do |m|
					 if m != newmember
						 ChatChannel.broadcast_to(m.user, {
							 title: "groupchat_#{chatroom.id}",
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
		parse_params
		myChatroomMember = ChatroomMember.find_by(chatroom: @chatroom, user: @current_user)
		if myChatroomMember != nil then myChatroomMember.destroy end
		respond_to do |format|
			format.html { }
			format.json { head :no_content}
		end
	end

	def show # responds to a GET request on "/api/chatroom/:id"
		puts "in chatroom_controller#show"
	end

	def create # responds to a POST request on "/api/chatroom"
		#using this function to create a new groupchat
		parse_params
		puts "in chatroom_controller#create"
		# name = params[:groupchat_name]
		# password = params[:groupchat_password]
		if Chatroom.find_by(name: @chatroom_name)
			render json: { error: "This groupchat name has already been taken"}, status: :conflict
		else
			if @chatroom_pw == nil
				myChatroom = Chatroom.create(name: name, owner: @current_user, isprivate: false)
			else
				myChatroom = Chatroom.create(name: name, owner: @current_user, isprivate: true, password: @chatroom_pw)
			end
			if myChatroom.save #success
				newMember = ChatroomMember.create(chatroom: myChatroom, user: @current_user)
				newMember.save
				puts "saving chatroom was a success! And adding current user as a member => #{newMember.save}"
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

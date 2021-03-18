class ChatroomMember < ApplicationRecord
	belongs_to :chatroom, class_name: "Chatroom", required: true
	belongs_to :user, class_name: "User", required: true
end

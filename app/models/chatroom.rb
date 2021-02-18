class Chatroom < ApplicationRecord
	belongs_to :user1, class_name: "User", required: true
	belongs_to :user2, class_name: "User", required: true
end

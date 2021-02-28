class Chatroom < ApplicationRecord
	belongs_to :owner, class_name: "User", required: true
	has_many :
end

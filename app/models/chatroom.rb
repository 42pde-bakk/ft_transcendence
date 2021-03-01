require 'json'

class Chatroom < ApplicationRecord
	# validates :name, uniqueness: true
	belongs_to :owner, class_name: "User", required: true
	# has_many :messages, dependent: :destroy
	# has_many :members, class_name: "User"

	def self.all_with_subscription_status(current_user)
		unless current_user
			return nil
		end
		obj = Chatroom.all
		obj.each do |o|
			if ChatroomMember.find_by(user: current_user, chatroom: o) != nil
				o.is_subscribed = true
			else
				o.is_subscribed = false
			end
		end
		return obj
	end
end

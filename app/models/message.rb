class Message < ApplicationRecord
	belongs_to :user, class_name: "User", required: true
	belongs_to :chatroom, class_name: "Chatroom", optional: true

	def str(message_receiver)
		if message_receiver == self.user
			"[Me]: #{self.msg}"
		elsif message_receiver.blocked_users.find_by(towards: self.user) # elsif BlockedUser.find_by(user: message_receiver, towards: self.user)
			"[Blocked User]: generic message"
		elsif self.chatroom&.mutes&.find_by(user: self.user)
			# do nothing cus you're fucking muted kiddo (It'll show up normally for yourself like you're shadowmuted)
		else
			"[#{self.user.name}]: #{self.msg}"
		end
	end
end

class PrivateMessage < ApplicationRecord
	belongs_to :from, class_name: "User", required: true

	def str(message_receiver)
		if message_receiver == self.from
			"[Me]: #{self.message}"
		elsif BlockedUser.find_by(user: message_receiver, towards: self.from)
			"[Blocked User]: generic message"
		else
			"[#{self.from.name}]: #{self.message}"
		end
	end
end

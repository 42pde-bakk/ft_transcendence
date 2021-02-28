class Message < ApplicationRecord
	belongs_to :from, class_name: "User", required: true

	def str(message_receiver)
		if message_receiver == self.from
			"[Me]: #{self.msg}"
		elsif BlockedUser.find_by(user: message_receiver, towards: self.from)
			"[Blocked User]: generic message"
		else
			"[#{self.from.name}]: #{self.msg}"
		end
	end
end

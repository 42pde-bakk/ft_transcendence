class PrivateMessage < ApplicationRecord
	belongs_to :from, class_name: "User", required: true

	def str
		# If "from"-User is blocked by "to"-User,
		# return "[Blocked user]: generic message"
		"#{self.from.name}: #{self.message}"
	end
end

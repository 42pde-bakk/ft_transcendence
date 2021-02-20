class PrivateChat < ApplicationRecord
	belongs_to :user1, class_name: "User", required: true
	belongs_to :user2, class_name: "User", required: true
	has_many :private_messages, dependent: :destroy

	# def self.get_old_messages(chat, currentuser)
	# 	chat.private_messages.each do |m|
	# 		ChatChannel.broadcast_to(currentuser, m)
	# 	end
	# end
	#
	def str
		"#{self.id}"
	end

	def self.puts(chat)
		STDERR.puts("chat's users are #{chat.user1.str} and #{chat.user2.str}")
	end

end

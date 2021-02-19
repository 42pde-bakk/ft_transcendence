class PrivateMessage < ApplicationRecord
	belongs_to :private_chat, required: true
	belongs_to :from, class_name: "User", required: true
end

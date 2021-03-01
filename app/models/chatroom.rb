class Chatroom < ApplicationRecord
	# validates :name, uniqueness: true
	belongs_to :owner, class_name: "User", required: true
	has_many :messages, dependent: :destroy
	has_many :members, class_name: "User"
end

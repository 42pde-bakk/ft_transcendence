class BlockedUser < ApplicationRecord
	belongs_to :user
	belongs_to :towards, class_name: "User"
end

class Notification < ApplicationRecord
	belongs_to :sender, class_name: "User"
	belongs_to :receiver, class_name: "User", required: true
	belongs_to :war, class_name: "War", required: false
end

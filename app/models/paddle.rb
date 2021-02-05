class Paddle #< ApplicationRecord
	# include ActiveModel::Model
	attr_accessor :x
	attr_accessor :y
	attr_accessor :height
	attr_accessor :width

	def initialize(x, y, height)
		@x = x
		@y = y
		@height = height
		@width = 15.0
		@velocity = 10
	end
end

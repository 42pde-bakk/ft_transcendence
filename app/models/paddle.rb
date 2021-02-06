class Paddle #< ApplicationRecord
	# include ActiveModel::Model
	attr_accessor :posx
	attr_accessor :posy
	attr_accessor :height
	attr_accessor :width
	attr_accessor :velocity

	def initialize(x, y, height)
		@posx = x
		@posy = y
		@height = height
		@width = 15.0
		@velocity = 10
	end
end

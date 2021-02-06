class Ball #< ApplicationRecord
	attr_accessor :radius
	attr_accessor :startingspeed
	attr_accessor :posx
	attr_accessor :posy

	def initialize(x, y, player, radius)
		@startingspeed = 4
		@radius = radius
		@posx = x
		@posy = y
		if player == 1
			@xvelocity = 10
		else
			@xvelocity = -10
		end
		@yvelocity = 5
	end
end

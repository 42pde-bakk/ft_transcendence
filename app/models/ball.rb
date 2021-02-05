class Ball #< ApplicationRecord
	def initialize(player, paddle, radius)
		@startingspeed = 4
		@radius = radius
		if player == 1
			@x = paddle.x + (paddle.width + 10 + @radius)
		elsif player == 2
			@x = paddle.x - (10 + @radius)
		end
		@y = paddle.y + paddle.height / 2
		@Xvelocity = 0.0
		@Yvelocity = 0.0

	end
end

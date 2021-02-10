class Ball #< ApplicationRecord

	def initialize(canvas_width, canvas_height)
		@radius = 5
		@posx = canvas_width / 2
		@posy = canvas_height / 2
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@turncounter = 0
		@xvelocity = 2

		if rand(1..2) == 1
			@xvelocity *= -1
		end
		@yvelocity = 0.5
	end

	def updatepos(players)
		@posx += @xvelocity
		@posy += @yvelocity
		if players[0].paddle.include?(@posx - @radius, @posy) or players[1].paddle.include?(@posx - @radius, @posy) \
    or players[0].paddle.include?(@posx, @posy) or players[1].paddle.include?(@posx, @posy) \
    or players[0].paddle.include?(@posx + @radius, @posy) or players[1].paddle.include?(@posx + @radius, @posy)
			@xvelocity *= -1
			@turncounter += 1
			@xvelocity *= 1.1
			@yvelocity *= 1.1
		end
		if @posy < @radius or @posy > @canvas_height - @radius
			@yvelocity *= -1
		end
		@turncounter
	end

	def reset
		@posx = @canvas_width / 2
		@posy = @canvas_height / 2
		@xvelocity = 2
		@yvelocity = 0.5
		if rand(1..2) == 1
			@xvelocity *= -1
		end
		if rand(1..2) == 1
			@yvelocity *= -1
		end
	end

	def posx
		@posx
	end
	def posy
		@posy
	end
	def nextpos
		[@posx.to_i + @xvelocity.to_i, @posy.to_i + @yvelocity.to_i]
	end
	def radius
		@radius
	end
	def xvelocity
		@xvelocity
	end
	def yvelocity
		@yvelocity
	end
end

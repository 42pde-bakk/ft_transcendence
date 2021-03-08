class Ball
	def initialize(canvas_width, canvas_height, extra_speed)
		@mult_value = 1.1
		@mult_value = 1.5 if extra_speed
		@radius = 5
		@posx = canvas_width / 2
		@posy = canvas_height / 2
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@turncounter = 0
		@xvelocity = 5

		if rand(1..2) == 1
			@xvelocity *= -1
		end
		@yvelocity = [2.5, 2.5 * rand(1..3) / 2].max
	end

	def updatepos(players)
		@posx += @xvelocity
		@posy += @yvelocity
		if players[0].paddle.include?(self) or players[1].paddle.include?(self)
			@xvelocity *= -@mult_value
			@turncounter += 1
			@yvelocity *= @mult_value * rand(1..3) / 2
		end
		if @posy < @radius or @posy > @canvas_height - @radius
			@yvelocity *= -1
		end
		@turncounter
	end

	def reset
		@posx = @canvas_width / 2
		@posy = @canvas_height / 2
		@xvelocity = 5
		if rand(1..2) == 1
			@xvelocity *= -1
		end
		@yvelocity = [2.5, 2.5 * rand(1..3) / 2].max
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

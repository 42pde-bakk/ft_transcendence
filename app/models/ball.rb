class Ball #< ApplicationRecord
	attr_accessor :radius
	attr_accessor :posx
	attr_accessor :posy

	def initialize(canvas_width, canvas_height)
		@radius = 5
		@posx = canvas_width / 2
		@posy = canvas_height / 2
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@turncounter = 0

		randint = rand(1..2)
		if randint == 1
			@xvelocity = 10
		else
			@xvelocity = -10
		end
		@yvelocity = 2
	end

	def updatepos(players)
		@posx += @xvelocity
		@posy += @yvelocity
		if players[0].paddle.include?(@posx - @radius, @posy) or players[1].paddle.include?(@posx - @radius, @posy) \
    or players[0].paddle.include?(@posx, @posy) or players[1].paddle.include?(@posx, @posy) \
    or players[0].paddle.include?(@posx + @radius, @posy) or players[1].paddle.include?(@posx + @radius, @posy)
			@xvelocity *= -1
			@turncounter += 1
		end
		if @posy < @radius or @posy > @canvas_height - @radius
			@yvelocity *= -1
		end
	end

	def reset
		@posx = @canvas_width / 2
		@posy = @canvas_height / 2
	end

	def posx
		@posx
	end
	def posy
		@posy
	end
	def radius
		@radius
	end
end

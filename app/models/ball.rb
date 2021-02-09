class Ball #< ApplicationRecord
	attr_accessor :radius
	attr_accessor :posx
	attr_accessor :posy

	def initialize(x, y, radius, xmax, ymax)
		@radius = radius
		@posx = x
		@posy = y
		@xmax = xmax
		@ymax = ymax

		randint = rand(1..2)
		if randint == 1
			@xvelocity = 10
		else
			@xvelocity = -10
		end
		@yvelocity = 2
	end

	def updatepos
		@posx += @xvelocity
		@posy += @yvelocity
		if @posx < 0 or @posx > @xmax
			@xvelocity *= -1
		end
		if @posy < 0 or @posy > @ymax
			@yvelocity *= -1
		end
		# if @posx < 0 then @posx *= -1 elsif @posx > @xmax then @posx = @xmax - (@posx - @xmax) end
		# if @posy < 0 then @posy *= -1 elsif @posy > @ymax then @posy = @ymax - (@posy - @ymax) end
	end
end

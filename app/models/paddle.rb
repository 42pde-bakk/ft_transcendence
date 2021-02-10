class Paddle
	def initialize(x, canvas_width, canvas_height)
		@height = 30
		@width = 15.0
		@velocity = 10
		@posx = x.to_i + (@width / 2)
		@posy = canvas_height / 2
		@canvas_width = canvas_width.to_i
		@canvas_height = canvas_height.to_i
		@startingx = @posx.to_i
	end

	def move(input)
		unless input
			return
		end
		if input[:type] == "paddle_up"
			@posy -= @velocity.to_i
			@posy = [@posy.to_i, @height / 2].max

		elsif input[:type] == "paddle_down"
			@posy += @velocity.to_i
			@posy = [@posy.to_i, @canvas_height.to_i - (@height / 2)].min
		end
	end

	def include?(ballx, bally)
		ballx.between?(@posx.to_i - (@width / 2), @posx.to_i + (@width / 2)) and bally.between?(@posy.to_i - (@height / 2), @posy.to_i + (@height / 2))
	end

	def reset
		@posx = @startingx.to_i
		@posy = @canvas_height / 2
	end

	def posx
		@posx
	end
	def posy
		@posy
	end
	def width
		@width
	end
	def height
		@height
	end
	def velocity
		@velocity
	end
end

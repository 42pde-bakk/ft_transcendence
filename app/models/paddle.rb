class Paddle
	def initialize(x, canvas_width, canvas_height)
		@height = 30
		@width = 15.0
		@velocity = 10
		@posx = x + @width / 2
		@posy = canvas_height / 2
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@startingx = @x
	end

	def move(input)
		# STDERR.puts "in paddle::move, input is #{input}"
		unless input
			return
		end
		STDERR.puts "input.type is #{input[:type]}"
		if input[:type] == "paddle_up"
			@posy -= @velocity
			@posy = [@posy, @height / 2].max

		elsif input[:type] == "paddle_down"
			@posy += @velocity
			@posy = [@posy, @canvas_height - (@height / 2)].min
		end
		STDERR.puts "xrange is #{@posx - (@width / 2)} - #{@posx + (@width / 2)}"
		STDERR.puts "yrange is #{@posy - (@height / 2)} - #{@posy + (@height / 2)}"
	end

	def include?(ballx, bally)
		ballx.between?(@posx.to_i - (@width / 2), @posx.to_i + (@width / 2)) and bally.between?(@posy.to_i - (@height / 2), @posy.to_i + (@height / 2))
	end

	def reset
		@posx = @startingx
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

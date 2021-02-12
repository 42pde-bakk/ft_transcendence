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

	def get_distance(a, b, ball)
		a_to_p = [ ball.posx - a[0], ball.posy - a[1] ] # Storing vector A->P

		a_to_b = [ b[0] - a[0], b[1] - a[1] ] # Storing vector A->B

		atb2 = a_to_b[0] ** 2 + a_to_b[1] ** 2 # Finding the squared magnitured of a_to_b

		atp_dot_atb = a_to_p[0] * a_to_p[0] + a_to_p[1] * a_to_b[1] # Dot product of a2p and a2b
		t = atp_dot_atb / atb2 # Normalized distance from a to the closest point
		closest_point = [a[0] + a_to_b[0] * t, a[1] + a_to_b[1] * t]
		unless closest_point[0].between?(a[0], b[0]) and closest_point[1].between?(a[1], b[1])
			return 100
		end
		Math.sqrt(((closest_point[0] - ball.posx) ** 2) + ((closest_point[1] - ball.posy) ** 2))
	end

	def include?(ball)
		topleft = [@posx - @width / 2, @posy - @height / 2]
		topright = [@posx + @width / 2, @posy - @height / 2]
		botleft = [@posx - @width / 2, @posy + @height / 2]
		botright = [@posx + @width / 2, @posy + @height / 2]
		if @posx > @canvas_width / 2
			if ball.xvelocity < 0 then return false end
			return get_distance(topleft, botleft, ball) < ball.radius
		else
			if ball.xvelocity > 0 then return false end
			return get_distance(topright, botright, ball) < ball.radius
		end
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

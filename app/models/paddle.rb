class Paddle
	def initialize(id, x, canvas_width, canvas_height, long_paddles)
		@id = id
		@height = 30
		@height *= 1.5 if long_paddles
		@width = 15.0
		@velocity = 5
		@posx = x.to_i + (@width / 2)
		@posy = canvas_height / 2
		@canvas_width = canvas_width.to_i
		@canvas_height = canvas_height.to_i
		@startingx = @posx.to_i
	end

	def move(input)
		return unless input

		if input[:type] == "paddle_up"
			@posy -= @velocity.to_i
			@posy = [@posy.to_i, @height / 2].max
		elsif input[:type] == "paddle_down"
			@posy += @velocity.to_i
			@posy = [@posy.to_i, @canvas_height.to_i - (@height / 2)].min
		end
	end

	def get_hit(ball)
		if @id == 0 then paddle_frontx = @posx + @width / 2 else paddle_frontx = @posx - @width / 2 end
		return false unless paddle_frontx.between?([ball.posx, ball.nextpos[0]].min, [ball.posx, ball.nextpos[0]].max)
		xdiff_ball = ball.nextpos[0] - ball.posx
		ydiff_ball = ball.nextpos[1] - ball.posy
		delta = ydiff_ball / xdiff_ball
		y_would_cross = delta * (paddle_frontx - ball.posx) + ball.posy
		str = "paddle_frontx is #{paddle_frontx}, paddle_y is #{[@posy - @width / 2, @posy + @height / 2]}
	ball is at #{[ball.posx, ball.posy]}, nextpos is #{ball.nextpos}
	xdiff_ball = #{xdiff_ball}, ydiff_ball = #{ydiff_ball}, delta = #{delta}
	y_would_cross: #{y_would_cross} = #{delta} * (#{paddle_frontx} - #{ball.posx}) + #{ball.posy}\n"
		# open('get_hit.txt', 'a') do |f| f << str
		# end
		return true if y_would_cross.between?(@posy - @height / 2 - ball.radius, @posy + @height / 2 + ball.radius)
		false
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

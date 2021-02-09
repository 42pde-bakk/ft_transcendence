class Gamestate
	attr_accessor :canvas_height
	attr_accessor :canvas_width
	attr_accessor :ball
	attr_accessor :paddles
	attr_accessor :status
	attr_accessor :ball_radius
	attr_accessor :inputs

	def initialize(gameid)
		@gameid = gameid
		paddles_height = 30.0
		@canvas_width = 200
		@canvas_height = 100
		@ball_radius = 5.0
		@status = "waiting"
		@paddles = Array.new(2)
		@paddles[0] =	Paddle.new(5, @canvas_height / 2 - (paddles_height / 2), paddles_height)
		@paddles[1] = Paddle.new(@canvas_width - 20, @canvas_height / 2 - (paddles_height / 2), paddles_height)
		@ball = Ball.new(@canvas_width / 2, @canvas_height / 2, @ball_radius, @canvas_width, @canvas_height)
		@inputs = Array.new
	end

	def sim_turn
		@paddles[0].move(@inputs.pop)
		@ball.updatepos
		send_config
	end

	def send_config
		obj = {
			config: {
				canvas: {
					width: @canvas_width,
					height: @canvas_height
				},
				paddles: [
					{
						width: @paddles[0].width,
						height: @paddles[0].height,
						x: @paddles[0].posx,
						y: @paddles[0].posy
					},
					{
						width: @paddles[1].width,
						height: @paddles[1].height,
						x: @paddles[1].posx,
						y: @paddles[1].posy
					}
				],
				ball: {
					radius: @ball.radius,
					x: @ball.posx,
					y: @ball.posy
				}
			}
		}
		ActionCable.server.broadcast("game_channel_#{@gameid}", obj)
	end
end
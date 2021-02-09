# 0, 0 - - 4, 0
# |           |
# |           |
# 0, 4 - - 4, 4

class Player
	attr_accessor :inputs

	def initialize(id, x, canvas_width, canvas_height)
		@id = id
		@score = 0
		@name = "Bot"
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@paddle = Paddle.new(x, @canvas_width, @canvas_height)
		@inputs = Array.new
	end

	def name
		@name
	end
	def name=(name)
		@name = name
	end
	def score
		@score
	end
	def inc_score
		@score += 1
	end
	def paddle
		@paddle
	end

	def add_move(new_move)
		@inputs.unshift(new_move)
	end

	def move
		if @inputs.length > 0
			@paddle.move(@inputs.pop)
		end
	end

end

class Gamestate
	def initialize(gameid)
		@gameid = gameid
		@canvas_width = 200
		@canvas_height = 100
		@status = "waiting"
		@players = [
			Player.new(0, 5, @canvas_width, @canvas_height),
			Player.new(1, @canvas_width - 20, @canvas_width, @canvas_height)
		]
		@ball = Ball.new(@canvas_width, @canvas_height)
	end


	def score
		if @ball.posx <= 0 then @players[1].inc_score else @players[0].inc_score end
		@players.each do |p|
			p.paddle.reset
		end
		@ball.reset
	end

	def sim_turn
		@players.each do |p|
			p.move
		end
		@ball.updatepos(@players)

		if @ball.posx <= 0 or @ball.posx >= @canvas_width
			score
		end

		if @players.any? {|p| p.score == 5}
			@status == "finished"
		end
		# send_config
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
						width: @players[0].paddle.width,
						height: @players[0].paddle.height,
						x: @players[0].paddle.posx,
						y: @players[0].paddle.posy
					},
					{
						width: @players[1].paddle.width,
						height: @players[1].paddle.height,
						x: @players[1].paddle.posx,
						y: @players[1].paddle.posy
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

	def status # simple getter method
		@status
	end
	def status=(status) # simple setter method
		@status = status
	end

	def add_input(type, id)
		STDERR.puts "adding input, id is #{id}, type is #{type}"
		@players[id].add_move({type: type, id: id})
	end
end

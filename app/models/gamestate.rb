# 0, 0 - - 4, 0
# |           |
# |           |
# 0, 4 - - 4, 4

class Player
	attr_accessor :inputs

	def initialize(id, x, canvas_width, canvas_height)
		@id = id
		@ai = true
		@score = 0
		@name = "Player #{id.to_i + 1}"
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@paddle = Paddle.new(x, @canvas_width, @canvas_height)
		@inputs = Array.new
		@status = "waiting"
	end

	def ai_sim(ball)
		if ball.nextpos[1].to_i > @paddle.posy.to_i + (@paddle.height.to_i / 3).to_i
			@paddle.move({type: "paddle_down", id: @id})
		elsif ball.nextpos[1].to_i < @paddle.posy.to_i - (@paddle.height.to_i / 3).to_i
			@paddle.move({type: "paddle_up", id: @id})
		end
	end

	def name
		@name
	end
	def name=(name)
		@name = name
		@ai = false
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

	def status
		@status
	end

	def toggle_ready
		if @status == "waiting"
			@status = "ready"
		elsif @status == "ready"
			@status = "waiting"
		end
	end

	def add_move(new_move)
		@inputs.unshift(new_move)
	end

	def move(ball)
		if @ai and rand(1..5) == 1
			ai_sim(ball)
		end
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
		@status = "running"
		@players = [
			Player.new(0, 5, @canvas_width, @canvas_height),
			Player.new(1, @canvas_width - 20, @canvas_width, @canvas_height)
		]
		@winner = "TBD"
		@msg = nil
		@turn = 0
		@ball = Ball.new(@canvas_width, @canvas_height)
	end

	def add_player(name, id)
		@players[id].name = name
	end

	def score
		if @ball.posx <= 0 then @players[1].inc_score else @players[0].inc_score end
		@players.each do |p|
			p.paddle.reset
		end
		@ball.reset
	end

	def sim_turn
		# if @players.any? {|p| p.status == "waiting"}
		# 	@status = "waiting"
		# end
		# if @status == "waiting"
		# 	if @players.all? {|p| p.status == "ready"}
		# 		@status = "running"
		# 	else
		# 		return sleep(2)
		# 	end
		# end
		@players.each do |p|
			p.move(@ball)
		end
		@turn = @ball.updatepos(@players)

		if @ball.posx <= 0 or @ball.posx >= @canvas_width
			score
		end

		if @players.any? {|p| p.score.to_i == 5} or @turn.to_i >= 100
			@status = "finished"
			if @players[0].score.to_i == @players[1].score.to_i
				@winner = "DRAW"
				@msg = "The game has ended in a draw, PepeHands"
			else
				if @players[0].score.to_i > @players[1].score.to_i then @winner = @players[0].name else @winner = @players[1].name end
				@msg = @winner + " wins!"
			end
		end
	end

	def send_config
		obj = {
			config: {
				status: @status,
				winner: @winner,
				message: @msg,
				canvas: {
					width: @canvas_width,
					height: @canvas_height
				},
				players: [
					{
						name: @players[0].name,
						score: @players[0].score,
						paddle: {
							width: @players[0].paddle.width,
							height: @players[0].paddle.height,
							x: @players[0].paddle.posx,
							y: @players[0].paddle.posy
						}
					},
					{
						name: @players[1].name,
						score: @players[1].score,
						paddle: {
							width: @players[1].paddle.width,
							height: @players[1].paddle.height,
							x: @players[1].paddle.posx,
							y: @players[1].paddle.posy
						}
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
		if type == "toggleReady"
			@players[id.to_i].toggle_ready
		end
		@players[id].add_move({type: type, id: id})
	end
end

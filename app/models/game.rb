# 0, 0 - - 4, 0
# |           |
# |           |
# 0, 4 - - 4, 4

class Player
	attr_accessor :inputs

	def initialize(id, x, canvas_width, canvas_height, user)
		@status = "ready"
		if user == nil or user.id < 3 then @ai = true else @ai = false end
		if user
			@name = user.name
			@user_id = user.id
			@status = "waiting"
		else
			@name = "Bot Feskir"
			@user_id = 0
		end
		@left_right = id
		@score = 0
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@paddle = Paddle.new(x, @canvas_width, @canvas_height)
		@inputs = Array.new
	end

	def ai_sim(ball)
		if ball.nextpos[1].to_i > @paddle.posy.to_i + (@paddle.height.to_i / 3).to_i
			@paddle.move({ type: "paddle_down", id: @left_right } )
		elsif ball.nextpos[1].to_i < @paddle.posy.to_i - (@paddle.height.to_i / 3).to_i
			@paddle.move({ type: "paddle_up", id: @left_right } )
		end
	end

	def name
		@name
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

	def user_id
		@user_id
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
		unless @ai
			@inputs.unshift(new_move)
		end
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

class Gamelogic
	def initialize(game)
		@game = game
		@canvas_width = 200
		@canvas_height = 100
		@status = "running"
		@players = [
			Player.new(0, 5, @canvas_width, @canvas_height, game.player1),
			Player.new(1, @canvas_width - 20, @canvas_width, @canvas_height, game.player2)
		]
		@winner = "TBD"
		@msg = nil
		@turn = 0
		@ball = Ball.new(@canvas_width, @canvas_height)
	end

	def score
		if @ball.posx <= 0 then @players[1].inc_score else @players[0].inc_score end
		@players.each do |p|
			p.paddle.reset
		end
		@ball.reset
	end

	def distribute_points(winner, loser)
		return if winner == nil or loser == nil or @game.gametype == "casual"

		if @game.gametype == "ranked"
			winner.elo += 1
			loser.elo -= 1
			winner.save
			loser.save
			winner.guild&.points += 1
			winner.guild&.save
		elsif @game.gametype == "wartime"
			g1 = winner.guild.active_war.guild1
			g2 = winner.guild.active_war.guild2
			return if g1 == nil or g2 == nil
			if g1 == winner.guild
				winner.guild.active_war.g1_points += 1
			elsif g2 == winner.guild
				winner.guild.active_war.g2_points += 1
			end
			winner.guild.active_war.save
		end
	end

	def finish_game
		@status = "finished"

		if @players[0].score.to_i == @players[1].score.to_i
			@winner = "DRAW"
			@msg = "The game has ended in a draw, PepeHands"
		else
			if @players[0].score.to_i > @players[1].score.to_i
				@winner = @players[0].name
				winner_id = @players[0].user_id
				loser_id = @players[1].user_id
			else
				@winner = @players[1].name
				winner_id = @players[1].user_id
				loser_id = @players[0].user_id
			end
			@msg = "#{@winner} wins!"
			distribute_points(User.find_by(id: winner_id), User.find_by(id: loser_id))
		end
	end

	def sim_turn
		if @players[0].status == "waiting" or @players[1].status == "waiting"
			@status = "waiting"
			return
		end

		@players.each do |p|
			p.move(@ball)
		end
		@turn = @ball.updatepos(@players)

		if @ball.posx <= 0 or @ball.posx >= @canvas_width
			score
		end

		if @players.any? {|p| p.score.to_i == 5} or @turn.to_i >= 100
			finish_game
		end
		send_config
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
		ActionCable.server.broadcast("game_channel_#{@game.id}", obj)
	end

	def status # simple getter method
		if @status == "finished"
			"finished"
		elsif @players[0].status == "waiting" or @players[1].status == "waiting"
			"waiting"
		else
			"running"
		end
	end

	def add_input(type, id, game_id)
		STDERR.puts "adding input, id is #{id}, type is #{type}"
		if type == "toggleReady"
			@players[id.to_i].toggle_ready
			if @players[0].status == "ready" and @players[1].status == "ready"
				GameJob.perform_later(game_id)
			end
		end
		@players[id].add_move({type: type, id: id})
	end

	def countdown
		@status = "countdown"
		3.downto(0) do |n|
			if n == 0 then @msg = nil else @msg = "Game starting in #{n}" end
			send_config
			sleep(1)
		end
		@status = "running"
		@msg = nil
	end
end

#noinspection RubyClassVariableNamingConvention
class Game < ApplicationRecord # This is a wrapper class
	belongs_to :war, :class_name => "War", required: false
	belongs_to :player1, :class_name => "User", required: true
	belongs_to :player2, :class_name => "User", required: false

	@@Gamelogics = Hash.new

	def mysetup
		@@Gamelogics[id] = Gamelogic.new(self)
	end

	def send_config
		if @@Gamelogics[id]
			@@Gamelogics[id].send_config
		end
	end

	def get_gamelogic
		@@Gamelogics[id]
	end

	def add_input(type, user_id)
		if @@Gamelogics[id]
			@@Gamelogics[id].add_input(type, user_id, id)
		end
	end

	def mydestructor
		@@Gamelogics[id] = nil
	end
end

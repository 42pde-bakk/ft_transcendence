class Game < ApplicationRecord
	include ActiveModel::Model

	# belongs_to :gameid, optional: true
	# has_one :gamestate, class_name: 'Gamestate', optional: false
	attr_accessor :status
	attr_accessor :canvas_width
	attr_accessor :canvas_height
	attr_accessor :paddles
	attr_accessor :ball

	def init_game(gameid)
		# @game = Game.find_by(id: gameid)
		@canvas_width = 800
		@canvas_height = 600
		@ball_radius = 20
		paddles_height = 50.0
		@status = "waiting"
		@paddles = Array.new(2)
		@paddles[0] =	Paddle.new(5, @canvas_height / 2 - (paddles_height / 2), paddles_height)
		@paddles[1] = Paddle.new(@canvas_width - 20, @canvas_height / 2 - (paddles_height / 2), paddles_height)
		STDERR.puts "Paddles is array at #{@paddles}"

		randint = rand(0..1)
		@ball = Ball.new(randint + 1, @paddles[randint], @ball_radius)

		GameJob.perform_later(gameid)
		STDERR.puts "Put gamejob in queue!"
	end
end

class GameState
  attr_accessor :canvas_height
  attr_accessor :canvas_width
  attr_accessor :ball
  attr_accessor :paddles
  attr_accessor :status
  attr_accessor :ball_radius

  def initialize(gameid, canvas)
    @gameid = gameid
    paddles_height = 30.0
    @canvas_width = canvas[0]
    @canvas_height = canvas[1]
    @ball_radius = 5.0
    @status = "waiting"
    @paddles = Array.new(2)
    @paddles[0] =	Paddle.new(5, @canvas_height / 2 - (paddles_height / 2), paddles_height)
    @paddles[1] = Paddle.new(@canvas_width - 20, @canvas_height / 2 - (paddles_height / 2), paddles_height)

    randint = rand(0..1)
    @ball = Ball.new(@canvas_width / 2, @canvas_height / 2, randint + 1, @ball_radius)
  end
end


class GameJob < ApplicationJob
  queue_as :default

  def perform(gameid)
    # game = Game.find_by(gameid: gameid)
    @game = GameState.new(gameid, [200, 100])
    STDERR.puts "Actioncable has #{ActionCable.server.connections.length} connections"
    broadcast_configuration(gameid)
  end

  def broadcast_configuration(gameid)
    sleep(1)
    STDERR.puts "Before broadcasting config to game_channel_#{gameid}"
    # STDERR.puts "canvas is #{@game.canvas_width}, #{@game.canvas_height}"
    ret = ActionCable.server.broadcast("game_channel_#{gameid}", {
      config: {
        canvas: {
          width: @game.canvas_width,
          height: @game.canvas_height
        },
        paddles: [
        {
          width: @game.paddles[0].width,
          height: @game.paddles[0].height,
          x: @game.paddles[0].posx,
          y: @game.paddles[0].posy
        },
        {
          width: @game.paddles[1].width,
          height: @game.paddles[1].height,
          x: @game.paddles[1].posx,
          y: @game.paddles[1].posy
        }
        ],
        ball: {
          radius: @game.ball.radius,
          x: @game.ball.posx,
          y: @game.ball.posy
        }
      }
      })
    STDERR.puts "After broadcasting config to game_channel_#{gameid}, returned #{ret}"
  end
end

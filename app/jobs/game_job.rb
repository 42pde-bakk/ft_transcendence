class GameJob < ApplicationJob
  queue_as :default

  def perform(gameid)
    @gameid = gameid
    @game = Game.find_by(gameid:gameid)
    STDERR.puts "JOB: @game is #{@game}"#, game canvas is = #{@game.canvas_width}"
    STDERR.puts "all games is #{Game.all}"
    # broadcast_configuration
  end

  def broadcast_configuration
    STDERR.puts "Before broadcasting config"
    STDERR.puts "canvas is #{@game.canvas_width}, #{@game.canvas_height}"
    STDERR.puts "@paddles is #{@game.paddles}"
    ActionCable.server.broadcast("game_channel_#{@gameid}", {
      config: {
        canvas: {
          width: @game.canvas_width,
          height: @game.canvas_height
        },
        paddles: [
        {
          width: @game.paddles[0].width,
          height: @game.paddles[0].height,
          velocity: @game.paddles[0].velocity
        },
        {
          width: @game.paddles[1].width,
          height: @game.paddles[1].height,
          velocity: @game.paddles[1].velocity
        }
        ],
        ball: {
          speed: @game.ball.startingSpeed,
          radius: @game.ball.radius
        }
      }
      })
    STDERR.puts "After broadcasting config"
  end
end

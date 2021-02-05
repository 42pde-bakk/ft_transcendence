class GameController < ApplicationController
	def index
	end

	def play
		@game_id = params[:id]
    @game = Game.new(gameid: @game_id)
		STDERR.puts "bitchboy better have my money"
		@game.init_game(@game_id)
		STDERR.puts "@game is #{@game}, its status is #{@game.status}"
		STDERR.puts "CONTROLLER: @game is #{@game}, game canvas is = #{@game.canvas_width}"

		@game.status = 'running'
    @game.save
		STDERR.puts "CONTROLLER: @game is #{@game}, game canvas is = #{@game.canvas_width}"

    @game # implicit return
	end
end

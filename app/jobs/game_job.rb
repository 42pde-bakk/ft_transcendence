class GameJob < ApplicationJob
	queue_as :default

	def perform(gameid)
		sleep(1)
		@game_channel = gameid
		@game = Game.find_by(room_nb: @game_channel)
		STDERR.puts("GameJob::perform(#{@game_channel}) ==> game = #{@game}")
		unless @game
			STDERR.puts("GameJob(#{gameid}) is null")
			@game.destroy
			return
		end
		@gamestate = @game.get_gamestate
		unless @gamestate
			STDERR.puts("gamestate is null")
			@game.destroy
			return
		end
		play_game
		@game.destroy
	end

	def play_game
		i = 0
		while @game and @gamestate and i < 100
			@gamestate.sim_turn
			sleep(0.1)
			i += 1
		end
		STDERR.puts "End of play_game"
	end
end

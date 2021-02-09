class GameJob < ApplicationJob
	queue_as :default

	def check
		unless @game
			STDERR.puts("GameJob(#{@game_channel}) is null")
			@game.destroy
			return false
		end
		@gamestate = @game.get_gamestate
		unless @gamestate
			STDERR.puts("gamestate is null")
			@game.destroy
			return false
		end
		true
	end

	def perform(gameid)
		sleep(1)
		@game_channel = gameid
		@game = Game.find_by(room_nb: @game_channel)
		STDERR.puts("GameJob::perform(#{@game_channel}) ==> game = #{@game}")
		unless check
			return
		end
		play_game
		@game.mydestructor
		@game.destroy
	end

	def play_game
		i = 0
		@gamestate.status = "running"
		while @game and @gamestate and @gamestate.status == "running" and i.to_i < 150
			@gamestate.sim_turn
			sleep(0.05)
			i += 1
		end
		STDERR.puts "End of play_game"
	end
end

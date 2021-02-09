class GameJob < ApplicationJob
	queue_as :default

	def check
		unless @game
			STDERR.puts("GameJob(#{gameid}) is null")
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
		@gamestate.status = "running"
		while @game and @gamestate and @gamestate.status == "running"
			@gamestate.sim_turn
			sleep(0.05)
		end
		STDERR.puts "End of play_game"
	end
end

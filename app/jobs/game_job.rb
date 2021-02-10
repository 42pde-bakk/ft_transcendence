class GameJob < ApplicationJob
	queue_as :default
	self.log_arguments = false

	private def args_info(job)
		''
	end

	def check
		unless @game
			@game.destroy
			return false
		end
		@gamestate = @game.get_gamestate
		unless @gamestate
			@game.destroy
			return false
		end
		true
	end

	def perform(gameid)
		@game_channel = gameid
		@game = Game.find_by(room_nb: @game_channel)
		unless check
			return
		end
		@gamestate.status = "running"
		play_game
		@game.mydestructor
		@game.destroy
	end

	def play_game
		while @game and @gamestate and @gamestate.status != "finished"
			@gamestate.sim_turn
			@gamestate.send_config
			sleep(0.08)
		end
	end
end

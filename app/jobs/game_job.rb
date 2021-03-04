class GameJob < ApplicationJob
	queue_as :default

	def perform(gameid)
		@game = Game.find(gameid) rescue nil
		if @game == nil then return end
		@game.mysetup
		@gamestate = @game.get_gamelogic

		play_game
		@game.mydestructor
		@game.destroy
	end

	def play_game
		while @gamestate.status != "finished"
			@gamestate.sim_turn
			sleep(0.05)
		end
	end
end

class GameJob < ApplicationJob
	queue_as :default

	def perform(gameid)
		@game = Game.find(gameid) rescue nil
		if @game == nil then return end

		@gamestate = @game.get_gamelogic
		play_game
		if @gamestate.status == "finished"
			@game.mydestructor
			@game.destroy
		end
	end

	def play_game
		@gamestate.countdown
		while @gamestate.status == "running"
			@gamestate.sim_turn
			sleep(0.05)
		end
	end
end

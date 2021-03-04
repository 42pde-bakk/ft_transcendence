class GameJob < ApplicationJob
	queue_as :default

	def perform(gameid)
		# @game_channel = gameid
		STDERR.puts("@game_channel is #{gameid}")
		@game = Game.find(gameid) rescue nil
		if @game == nil then return end
		@gamestate = @game.get_gamelogic

		# @gamestate.status = "waiting"
		play_game
		@game.mydestructor
		@game.destroy
	end

	def play_game
		puts "Start of play_game"
		while @game and @gamestate and @gamestate.status != "finished"
			@gamestate.sim_turn
			@gamestate.send_config
			sleep(0.05)
		end
		puts "Job done"
	end
end

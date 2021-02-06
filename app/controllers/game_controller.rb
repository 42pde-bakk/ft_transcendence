class GameController < ApplicationController
	def index
	end

	def play
		@game_id = params[:id]
		STDERR.puts "Before gamejob"
		GameJob.perform_later(params[:id])
		STDERR.puts "After gamejob"
	end

end

class GameController < ApplicationController
	before_action :set_params

	def index
		STDERR.puts "index baby"
	end

	def play
		STDERR.puts "yoyo"
		# @game_id = params[:room_number]
		# mygame = Gamestate.new(room_nb: @game_id)
		# saveret = mygame.save
		# STDERR.puts("created a new gamestate, @game_id is #{@game_id}")
		# STDERR.puts("mygame is #{mygame}, its gameid is #{mygame.room_nb}, saveret = #{saveret}")
		# GameJob.perform_later(params[:room_number])
	end

	def set_params
		STDERR.puts "called set_params"
		@game_id = params[:room_number]
	end
end

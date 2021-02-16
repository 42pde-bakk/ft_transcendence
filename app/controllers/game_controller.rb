class GameController < ApplicationController
	before_action :set_params
	skip_before_action :verify_authenticity_token

	def index
	end

	def join
		# until @game
		# 	sleep(0.5)
		# 	@game = Game.find_by(room_nb: @game_id)
		# end
		# @game.add_player(@user)
	end

	def set_params
		@user = User.find_by log_token: cookies[:log_token]
		STDERR.puts("BABYBACKBITCH user = #{@user}")
		@game_id = params[:room_number]
	end
end

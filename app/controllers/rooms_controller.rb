class RoomsController < ApplicationController
	def show
		@room_id = params[:id]
	end
end

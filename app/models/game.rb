class Game < ApplicationRecord
	# attr_accessor :gamestate
	@@gamestates = Hash.new

	def mysetup
		@@gamestates[room_nb] = Gamestate.new(room_nb)
		# @gamestate = @@gamestates[room_nb]
		STDERR.puts "Game::setup, room_number is #{room_nb}"
	end

	def send_config
		@@gamestates[room_nb].send_config
	end

	def get_gamestate
		@@gamestates[room_nb]
	end

	def add_input(type, id)
		@@gamestates[room_nb].inputs.unshift({type: type, id: id})
	end
end

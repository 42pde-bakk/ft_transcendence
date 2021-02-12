class Game < ApplicationRecord
	# attr_accessor :gamestate
	@@gamestates = Hash.new

	def mysetup
		@@gamestates[room_nb] = Gamestate.new(room_nb)
	end

	def send_config
		if @@gamestates[room_nb]
			@@gamestates[room_nb].send_config
		end
	end

	def get_gamestate
		@@gamestates[room_nb]
	end

	def add_input(type, id)
		if @@gamestates[room_nb]
			@@gamestates[room_nb].add_input(type, id)
		end
	end

	def mydestructor
		@@gamestates[room_nb] = nil
	end
end

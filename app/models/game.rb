class Game < ApplicationRecord
	has_one  :player1, :class_name => "User"
	has_one  :player2, :class_name => "User"
	has_many    :spectators, :class_name => "User"

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

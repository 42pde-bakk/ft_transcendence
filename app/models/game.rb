class Game < ApplicationRecord
	# belongs_to  :player1, :class_name => "User"
	# belongs_to  :player2, :class_name => "User"
	has_many    :spectators, :class_name => "User"

	@@gamestates = Hash.new

	def mysetup
		@@gamestates[room_nb] = Gamestate.new(room_nb)
	end

	def add_player(new_user)
		if !player1
			player1 = new_user
		elsif !player2
			player2 = new_user
		else
			spectators += new_user
		end
		STDERR.puts("player1 = #{player1}, player2 = #{player2}, spectators = #{spectators}")
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

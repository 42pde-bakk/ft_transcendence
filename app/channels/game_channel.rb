# This tutorial helped me https://www.youtube.com/watch?v=t9iubpbqmnM
# A lot of tutorials used Rails 4 or 5 which messed things up without me realizing it, but this guy uses 6
# And he actually also has some errors that he solves on the fly which is nice

class GameChannel < ApplicationCable::Channel
	@@subscribers = Hash.new

	def find_game(game_id)
		@game = Game.find_by(room_nb: game_id)
		if @game
			STDERR.puts("Found game by room_nb: #{game_id}")
		else
			@game = Game.create(room_nb: game_id)
			STDERR.puts "GAME CREATED, game = #{@game}, game.room_nb is #{@game.room_nb}"
			@game.mysetup
			saveret = @game.save
			STDERR.puts("saveret = #{saveret}")
		end
	end

	def subscribed
		game_id = params[:game_id]
		stream_from "game_channel_#{game_id}"
		@@subscribers[game_id] ||= 0 # if it's nil, it'll be set to be 0, poggers
		@@subscribers[game_id] += 1

		find_game(game_id)
		@game.send_config
		# GameJob.perform_later(game_id)
	end

	def receive(data)
		# STDERR.puts("Data is #{data}")
	end

	def input(data)
		STDERR.puts("inputting #{data}, game is #{@game}")
		if @game
			@game.add_input(data["type"], data["id"])
		end
	end

	def unsubscribed
		# Any cleanup needed when channel is unsubscribed
		@@subscribers[params[:game_id]] -= 1
		# stop_stream_from "game_channel_#{params[:game_id]}"
	end
end

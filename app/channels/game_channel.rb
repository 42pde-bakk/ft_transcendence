# This tutorial helped me https://www.youtube.com/watch?v=t9iubpbqmnM
# A lot of tutorials used Rails 4 or 5 which messed things up without me realizing it, but this guy uses 6
# And he actually also has some errors that he solves on the fly which is nice

class GameChannel < ApplicationCable::Channel
	@@subscribers = Hash.new

	def find_game(game_id)
		@game = Game.find_by(room_nb: game_id)
		unless @game
			@game = Game.create(room_nb: game_id)
			STDERR.puts "game = #{@game}, game.room_nb is #{@game.room_nb}"
			@game.mysetup
			@game.save
		end
	end

	def subscribed
		STDERR.puts("Game_channel_#{params[:game_id]} :: subscribed")
		game_id = params[:game_id]
		stream_from "game_channel_#{game_id}"
		@@subscribers[game_id] ||= 0 # if it's nil, it'll be set to be 0, poggers
		@@subscribers[game_id] += 1

		find_game(game_id)
		@game.send_config
		if @@subscribers[game_id] == 1
			GameJob.perform_later(game_id)
		end
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

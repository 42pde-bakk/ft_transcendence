# This tutorial helped me https://www.youtube.com/watch?v=t9iubpbqmnM
# A lot of tutorials used Rails 4 or 5 which messed things up without me realizing it, but this guy uses 6
# And he actually also has some errors that he solves on the fly which is nice

class GameChannel < ApplicationCable::Channel
	@@subscribers = Hash.new

	def subscribed
		# STDERR.puts("In gamechannel::subscribed, params is #{params}")
		game_id = params[:game_id]
		stream_from "game_channel_#{game_id}"
		@@subscribers[game_id] ||= 0 # if it's nil, it'll be set to be 0, poggers
		@@subscribers[game_id] += 1

		@game = Game.find(game_id) rescue nil
		if @game
			@game.send_config
		end
	end

	def receive(data)
	end

	def input(data)
		if @game
			if current_user == @game.player1
				id = 0
			elsif current_user == @game.player2
				id = 1
			else
				return false
			end
			@game.add_input(data["type"], id)
		end
		true
	end

	def unsubscribed
		# Any cleanup needed when channel is unsubscribed
		@@subscribers[params[:game_id]] -= 1
		# stop_stream_from "game_channel_#{params[:game_id]}"
	end

end

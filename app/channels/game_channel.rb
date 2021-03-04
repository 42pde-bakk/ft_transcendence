# This tutorial helped me https://www.youtube.com/watch?v=t9iubpbqmnM
# A lot of tutorials used Rails 4 or 5 which messed things up without me realizing it, but this guy uses 6
# And he actually also has some errors that he solves on the fly which is nice

class GameChannel < ApplicationCable::Channel
	@@subscribers = Hash.new

	def subscribed
		STDERR.puts("In gamechannel::subscribed, params is #{params}")
		game_id = params[:game_id]
		stream_from "game_channel_#{game_id}"
		@@subscribers[game_id] ||= 0 # if it's nil, it'll be set to be 0, poggers
		@@subscribers[game_id] += 1

		@game = Game.find(game_id) rescue nil
		if @game
			@game.send_config
		else
			puts "Someting wrong"
		end
	end

	def receive(data)
		# STDERR.puts("Data is #{data}")
	end

	def input(data)
		# user = User.find_by()
		# STDERR.puts("inputting #{data}, game is #{@game}, params is #{params}, current_user is #{current_user.id}")
		if @game
			if current_user == @game.player1 then id = 0 elsif current_user == @game.player2 then id = 1 else return end
			@game.add_input(data["type"], id)
		end
	end

	def unsubscribed
		# Any cleanup needed when channel is unsubscribed
		@@subscribers[params[:game_id]] -= 1
		# stop_stream_from "game_channel_#{params[:game_id]}"
	end

end

# This tutorial helped me https://www.youtube.com/watch?v=t9iubpbqmnM
# A lot of tutorials used Rails 4 or 5 which messed things up without me realizing it, but this guy uses 6
# And he actually also has some errors that he solves on the fly which is nice

class GameChannel < ApplicationCable::Channel
	def subscribed
		stream_from "game_channel_#{params[:game_id]}"
		STDERR.puts "I just subscribed!"
	end

	def receive(data)
		STDERR.puts("Data is #{data}")
	end

	def unsubscribed
		# Any cleanup needed when channel is unsubscribed
		STDERR.puts "I just unsubbed"
		stop_stream_from "game_channel_#{params[:game_id]}"
	end
end

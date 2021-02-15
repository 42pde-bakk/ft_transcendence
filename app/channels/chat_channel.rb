class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def input(data)
    STDERR.puts("chat_channel received #{data}")
    # ActionCable.server.broadcast("game_channel_#{@gameid}", obj)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

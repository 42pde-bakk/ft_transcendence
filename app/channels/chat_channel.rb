class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "chat_channel"
    stream_for current_user
  end

  # def receive(data)
  #   ActionCable.server.broadcast("chat_channel", data)
  # end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

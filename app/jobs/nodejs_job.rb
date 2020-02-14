class MessageBroadcastJob < ApplicationJob
  queue_as :default
  def perform(data)
    RoomChannel.broadcast_to("asd")
  end
end

class ProfileBroadcastJob < ApplicationJob
  queue_as :default
  def perform(message)
    # ActionCable.server.broadcast_to(render_message(message))
    p "-----------------"
    p message
    p "-----------------"
    ActionCable.server.broadcast 'profile_channel', message:message
  end
end

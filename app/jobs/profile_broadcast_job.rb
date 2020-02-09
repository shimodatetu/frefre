class ProfileBroadcastJob < ApplicationJob
  queue_as :default
  def perform(message)
    # ActionCable.server.broadcast_to(render_message(message))
    ActionCable.server.broadcast 'profile_channel', message:message
  end
end

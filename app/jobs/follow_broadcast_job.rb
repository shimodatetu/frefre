class FollowBroadcastJob < ApplicationJob
  queue_as :default
  def perform(follow)
    ActionCable.server.broadcast 'follow_channel', data: follow
  end
end

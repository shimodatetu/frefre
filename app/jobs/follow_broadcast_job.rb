class FollowBroadcastJob < ApplicationJob
  queue_as :default
  def perform(data)
    ActionCable.server.broadcast 'follow_channel', following_id: data[0],follower_id: data[1]
  end
end

class NoticeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast('notice_channel',notice_id: message.id,users:[message.users.first,message.users.last] )
  end

end

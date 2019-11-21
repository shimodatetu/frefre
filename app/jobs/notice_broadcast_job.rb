class NoticeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast('notice_channel',notice_id: message.notice_id,message: render_message(message),users:[message.users.first,message.users.last] )
  end

  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: {chat: message })
  end
end

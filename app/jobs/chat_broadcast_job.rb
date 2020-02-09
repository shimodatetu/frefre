class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast('chat_channel',notice_id: message.notice_id,chat:message,chat_id:message.notice.chats.all.count,message: render_message(message) )
  end

  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: {chat: message })
  end
end

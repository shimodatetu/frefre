class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    p "asd"
    #ActionCable.server.broadcast('notice_channel',notice_id: message.message.notice_id,[message.notice.users.first,message.notice.users.last] message: render_message(message))
  end

  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: {chat: message })
  end
end

class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat)
    ActionCable.server.broadcast('chat_channel',chat:chat,chat_id:chat.notice.chats.all.count,message: render_message(chat),type:"accept")
    if chat.id == chat.notice.chats.first.id
      ChatChannel.broadcast_to(chat.user,chat:chat,chat_id:chat.notice.chats.all.count,type:"new_maker")
    else
      ChatChannel.broadcast_to(chat.user,chat:chat,chat_id:chat.notice.chats.all.count,type:"maker")
    end
  end

  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'chats/chat', locals: {chat: message })
  end
end

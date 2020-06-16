class ChatChannel < ApplicationCable::Channel

  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "chat_channel"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def make(data)
    if logged_in?
      notice = Notice.find(data['group_id'].to_i)
      chat = Chat.new()
      chat.main_jp = data['content_jap']
      chat.main_en = data['content_eng']
      chat.notice_id = notice.id
      chat.user_id = current_user.id
      notice = chat.notice
      #ActionCable.server.broadcast 'chat_channel', chat_num:notice.chats.count,user:chat.user_id.to_s,notice_id:chat.notice_id
      chat.save!
    end
  end
  def image(data)
    if logged_in?
      chat = Chat.new()
      chat.image = data['image']
      chat.notice_id = data['group_id']
      chat.user_id = current_user.id
      chat.save
    end
  end
end

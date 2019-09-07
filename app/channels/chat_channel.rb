class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end


  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def make(data)
    notice = Notice.find(data['group_id'].to_i)
    chat = Chat.new()
    chat.main_jp = data['content_jap']
    chat.main_en = data['content_eng']
    chat.notice_id = notice.id
    chat.user_id = current_user.id
    chat.save!
  end
  def image(data)
    chat = Chat.new()
    chat.image = data['image']
    chat.notice_id = data['group_id']
    chat.user_id = current_user.id
    chat.save
  end
end

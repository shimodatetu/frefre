class NoticeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notice_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def make(data)
    if (notice = current_user.notices.includes(:users).where('users.id' => data['address'])).blank?
      notice = Notice.new()
      notice.users << User.find(data['address'])#最初相手
      notice.users << current_user
      if notice.save
        chat = Chat.new()
        chat.main_en = data['mes_en']
        chat.main_jp = data['mes_jp']
        chat.user_id = current_user.id
        chat.notice_id = notice.id
        chat.save!
      end
    else

      p "------------------------"
      p (notice = current_user.notices.includes(:users).where('users.id' => data['address'])).blank?
      p "----------------------------"
      p notice[0].id
      p "----------------------------"
      chat = Chat.new()
      chat.main_en = data['mes_en']
      chat.main_jp = data['mes_jp']
      chat.user_id = current_user.id
      chat.notice_id = notice[0].id
      chat.save!
    end
  end
end

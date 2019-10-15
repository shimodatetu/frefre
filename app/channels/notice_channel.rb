class NoticeChannel < ApplicationCable::Channel

  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "notice_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def make(data)
    if logged_in?
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
          info = Userinfo.new()
          info.title_en = 'You get a direct message from ' + h(notice.users[1].name) + '!'

          info.title_jp = h(notice.users[1].name) + 'からダイレクトメッセージがありました！'

          info.message_en = 'You get a direct message from ' + h(notice.users[1].name) + '.
          Please click on the url below and check the message.
          https://www.frefreforum.com/profile/5/'+notice.id.to_s

          info.message_jp = h(notice.users[1].name) + 'からダイレクトメッセージがありました！
          下記のURLをクリックしてメッセージを確認してください。
          https://www.frefreforum.com/profile/5/' + notice.id.to_s
          info.user_id = notice.users[0].id
          info.save
        end
      else
        chat = Chat.new()
        chat.main_en = data['mes_en']
        chat.main_jp = data['mes_jp']
        chat.user_id = current_user.id
        chat.notice_id = notice[0].id
        chat.save!
      end
    end
  end
end

class NoticeController < ApplicationController
  def show
    if Chat.present?
      @notice = Notice.find(params[:id])
      @chat = Chat.new
      thread_page_num = 20.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = @notice.chats.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:id].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
        page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
        if page_id - page_max_half < 0
         end_num = page_show_max
        elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
        else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
        end
      end
      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
    else
      @thread_page_num = 0
      @page_id = 0
      @page_num = 0
      @start_num = 0
      @end_num = 0
    end
  end
  def create
    if (notice = current_user.notices.includes(:users).where('users.id' => params['address'])).blank?
      notice = Notice.new()
      notice.users << User.find_by(id:params['address'])#最初相手
      notice.users << current_user
      if notice.save
        chat = Chat.new()
        chat.main_en = params['mes_en']
        chat.main_jp = params['mes_jp']
        if data[:type] == "image"
          post.pict = data[:pict]
        else
          post.video = data[:video]
          post.subtitle_en = params['subcontent_jap']
          post.subtitle_jp = params['subcontent_jap']
        end
        chat.user_id = current_user.id
        chat.notice_id = notice.id
        chat.save!
        info = Userinfo.new()
        info.title_en = 'You got a direct message from ' + h(notice.users[1].name) + '!'

        info.title_jp = h(notice.users[1].name) + 'からダイレクトメッセージがありました！'

        info.message_en = 'You got a direct message from ' + h(notice.users[1].name) + '.
        Please click on the url below and check the message.
        https://www.frefreforum.com/profile/5/'+notice.id.to_s

        info.message_jp = h(notice.users[1].name) + 'からダイレクトメッセージがありました！
        下記のURLをクリックしてメッセージを確認してください。
        https://www.frefreforum.com/profile/5/' + notice.id.to_s
        info.user_id = notice.users[0].id
        if info.save
          NoticeMailer.notice_mail([User.find_by(id:id.to_i).email,info.title_en,info.title_jp,
            info.message_en,info.message_jp,params[:url_data]]).deliver_now
        end
      end
    else
      chat = Chat.new()
      chat.main_en = params['mes_en']
      chat.main_jp = params['mes_jp']
      chat.user_id = current_user.id
      chat.notice_id = notice[0].id
      chat.save!
    end
  end
  def new
    @notice = Notice.new
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
  end
end

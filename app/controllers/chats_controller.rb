class ChatsController < ApplicationController
  def create
    data = params[:chat]
    notice = Notice.find(params["group_num"])
    if notice
      chat = Chat.new()
      chat.notice_id = notice.id
      chat.user_id = current_user.id
      if data[:type] == "image" && data[:pict] != nil
        chat.pict = data[:pict]
        chat.save
      elsif data[:type] == "video" && data[:video] != nil
        #trans(params)d
        chat.subtitle_en = data[:subtitle_en]
        chat.subtitle_jp = data[:subtitle_jp]
        chat.video = data[:video]
        chat.save
      end
    end
    #chat.find_by(id:params[:post][:post_id]).update(pict:params[:post][:pict])
  end
end

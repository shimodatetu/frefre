class OfficeController < ApplicationController
  def user_info
    user_id = params[:user_id]
    p user_id.to_i
    if (user_id .to_i != 0 || user_id == "0") && params["title_en"] != "" && params["title_jp"] != "" && params["message_en"] != "" && params["message_jp"] != ""
      if user_id == "0"
        info = Userinfo.new()
        info.title_en = params[:title_en]
        info.title_jp = params[:title_jp]

        info.message_en = params[:message_en]
        info.message_jp = params[:message_jp]

        for user in User.all
          info.user_id = user.id
          info.save
        end
      else
        info = Userinfo.new()
        info.title_en = params[:title_en]
        info.title_jp = params[:title_jp]

        info.message_en = params[:message_en]
        info.message_jp = params[:message_jp]

        info.user_id = user_id.to_i
        info.save
      end
    end
  end
end

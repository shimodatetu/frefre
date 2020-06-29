class ProfileChannel < ApplicationCable::Channel
  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "profile_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  def change_detail(data)
    if logged_in?
      if data["type"] == "username"
        current_user.update(name:data["data"])
      elsif data["type"] == "userid"
        current_user.update(user_search_id:data["data"])
      elsif data["type"] == "private"
        current_user.update(able_see:data["data"])
      end
    end
  end

  def change(data)
    if logged_in? && current_user.usertype != "event"
      user = current_user;
      if user.update(name:data["username"],country:data["country"],gender:data["gender"],profile_en:data["profile_en"],
        profile_jp:data["profile_jp"],able_see:data["able_see"])
      else
        redirect_to "/"
      end
    end
  end
end

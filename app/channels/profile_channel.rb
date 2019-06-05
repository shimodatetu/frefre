class ProfileChannel < ApplicationCable::Channel
  def subscribed
    stream_from "profile_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def change(data)
    user = current_user;
    p user.update(name:data["username"],country:data["country"],gender:data["gender"],profile_en:data["profile_en"],
      profile_jp:data["profile_jp"],able_see:data["able_see"])
  end
end

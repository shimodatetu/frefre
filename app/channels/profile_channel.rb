class ProfileChannel < ApplicationCable::Channel
  def subscribed
    stream_from "profile_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def change(data)
    user = current_user;
    user.update(name:data["username"],birth_year:data["year"],birth_month:data["month"],
      birth_day:data["date"],country:data["country"],gender:data["gender"],profile_en:data["profile_en"],
      profile_jp:data["profile_jp"],able_see:data["able_see"])
  end
end

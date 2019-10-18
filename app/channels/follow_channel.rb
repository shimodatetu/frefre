class FollowChannel < ApplicationCable::Channel

  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "follow_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def following(data)
    if logged_in?
      follow_id = data['id'].to_i
      if data['type'] == "follow"
        if current_user.following_id?(follow_id) == nil
          current_user.follow_id!(follow_id)
        end
      elsif data['type'] == "unfollow"
        if current_user.following_id?(follow_id) != nil
          current_user.unfollow_id!(follow_id)
        end
      end
    end
  end
end

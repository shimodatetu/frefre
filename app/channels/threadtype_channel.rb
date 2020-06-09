class ThreadtypeChannel < ApplicationCable::Channel
  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "follow_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def join(data)
    if logged_in?
      join_id = data['id'].to_i
      if data['type'] == "join"
        if current_user.joining_id?(follow_id) == nil
          current_user.join_id!(follow_id)
        end
      elsif data['type'] == "unjoin"
        if current_user.joining_id?(join_id) != nil
          current_user.unjoin_id!(join_id)
        end
      end
    end
  end
end

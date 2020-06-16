class ThreadtypeChannel < ApplicationCable::Channel
  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "threadtype_channel"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def joining(data)
    if logged_in?
      join_id = data['id'].to_i
      if data['type'] == "join"
        Threadtype.find_by(id:join_id).users << User.find_by(id:current_user.id)
        ThreadtypeChannel.broadcast_to(current_user, joining_id: current_user.id,joiner_id: join_id)
      elsif data['type'] == "unjoin"
        Threadtype.find_by(id:join_id).user_threadtypes.find_by(user_id:current_user.id).delete
        ThreadtypeChannel.broadcast_to(current_user, joining_id: current_user.id,joiner_id: join_id)
      end
    end
  end
end

class ApprovalChannel < ApplicationCable::Channel

  def logged_in?
    !current_user.nil?
  end
  def subscribed
    stream_from "approval_channel"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def add(data)
    threadtype_id = data['id'].to_i
    if logged_in? && (threadtype = Threadtype.find_by(id:threadtype_id)) != nil && threadtype.approval == "approval" && Approval.find_by(user_id:current_user.id,threadtype_id:threadtype_id) == nil
      Approval.create(user_id:current_user.id,threadtype_id:threadtype_id)
      ApprovalChannel.broadcast_to(current_user, threadtype_id:threadtype_id)
    end
  end
end

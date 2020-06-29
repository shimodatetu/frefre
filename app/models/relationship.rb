class Relationship < ApplicationRecord

  belongs_to :follower, class_name: "User", optional: true
  belongs_to :following, class_name: "User", optional: true
  validates :follower_id, presence: true
  validates :following_id, presence: true

  #after_destroy { FollowBroadcastJob.perform_later self  }
  after_destroy :do_alert
  after_save :do_alert
  def do_alert
    FollowBroadcastJob.perform_later [self["following_id"],self["follower_id"]]
  end
end

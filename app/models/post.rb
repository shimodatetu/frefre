class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :reportposts

  has_one_attached :pict
  has_one_attached :video
  validate :pict_presence

  def pict_presence
    if pict.attached?
      if !pict.content_type.in?(%('image/jpeg image/png'))
        errors.add(:pict, 'にはjpegまたはpngファイルを添付してください')
      end
    end
  end

  def video_presence
    if video.attached?
      if !video.content_type.in?(%('video/m4a video/mp4'))
        errors.add(:video, 'にはjpegまたはpngファイルを添付してください')
      end
    end
  end

  #after_create_commit { MessageBroadcastJob.perform_later self }
  #mount_uploader :image, ImageUploader
end

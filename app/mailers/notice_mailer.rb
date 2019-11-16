class NoticeMailer < ApplicationMailer
  def notice_mail(data)
    @data = data
    mail to: data[0], subject: data[1]+"/"+data[2]
  end
end

class EverydayMailer < ApplicationMailer
  default from: "info@frefre.net"

  def everyday_mail(user,group_have)
    @user = user
    @group_have = group_have
    p "asd1"
    mail to: "tetuprogram@yahoo.co.jp", subject: "Notice from FreFre office / FreFre事務局からのお知らせ"
    p "asd2"
  end
end

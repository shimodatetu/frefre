class EverydayMailer < ApplicationMailer
  default from: "info@frefre.net"

  def everyday_mail(user,group_have)
    @user = user
    @group_have = group_have
    mail to: "tetuprogram@yahoo.co.jp", subject: "Notice from FreFre office / FreFre事務局からのお知らせ"
  end
end

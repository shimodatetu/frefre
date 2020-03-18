class RegisterMailer < ApplicationMailer
  default from: "info@frefre.net"

  def send_confirm_mail(user)
    @user = user
    mail(
      subject: "会員登録が・・・",
      to: @user.email
    )
  end
end

class ContactMailer < ApplicationMailer
  def contact_mail(data)
    @data = data
    mail to: "frefre@info.net", subject: "FreFreへのお問い合わせ"
  end
end

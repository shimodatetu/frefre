class ContactMailer < ApplicationMailer
  def contact_mail(data)
    @data = data
    mail to: "info@frefre.net", subject: "FreFreへのお問い合わせ"
  end
end

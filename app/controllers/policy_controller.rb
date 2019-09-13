class PolicyController < ApplicationController
  def mail
    ContactMailer.contact_mail(params["contact_mes"][0]).deliver_now
  end
end


class PolicyController < ApplicationController
  def mail
    #contact_data
    #0:name
    #1:username
    #2:Mail
    #3:phone
    #4:country
    #5:message
    valid_address = /\A[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$\z/
    valid_phone = /\A\d{11}\z/
    if params["contact_data"][0]!="" && params["contact_data"][2]!="" && (params["contact_data"][2] =~ valid_address) == 0 &&
       params["contact_data"][3]!="" && (params["contact_data"][3] =~ valid_phone) == 0 && params["contact_data"][4]!="" &&
       params["contact_data"][5]!=""
      ContactMailer.contact_mail(params["contact_data"]).deliver_now
      flash_set("You successed to send","投稿に成功しました","success")
    end
  end

  def flash_set(en,jp,type)
    flash["alert_en"] = en
    flash["alert_jp"] = jp
    flash["alert_type"] = type
    render "contact"
  end
end


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
    if params["contact_data"][0] == ""
      flash.now[:failed_jp] == "名前が入力されていません。"
      flash.now[:failed_en] == "Name is not inputed."
      flash_set("You failed to send","投稿に失敗","error")
    elsif params["contact_data"][1] == ""
      flash.now[:failed_jp] == "ユーザーネームが入力されていません。"
      flash.now[:failed_en] == "Username is not inputed."
      flash_set("You failed to send","投稿に失敗","error")
    elsif params["contact_data"][2] == ""
      flash.now[:failed_jp] == "メールアドレスが入力されていません。"
      flash.now[:failed_en] == "Mail Address is not inputed."
      flash_set("You failed to send","投稿に失敗","error")
    elsif (params["contact_data"][2] =~ valid_address) == 0
      flash.now[:failed_jp] == "メールアドレスが間違っています。"
      flash.now[:failed_en] == "Mail Address is wrong."
      flash_set("You failed to send","投稿に失敗","error")
    elsif params["contact_data"][3] == ""
      flash.now[:failed_jp] == "電話番号が入力されていません。"
      flash.now[:failed_en] == "Phone Number is not inputed."
      flash_set("You failed to send","投稿に失敗","error")
    elsif (params["contact_data"][3] =~ valid_phone) == 0
      flash.now[:failed_jp] == "電話番号が間違っています。"
      flash.now[:failed_en] == "Phone Number is wrong."
      flash_set("You failed to send","投稿に失敗","error")
    elsif params["contact_data"][4] == ""
      flash.now[:failed_jp] == "出身国が入力されていません。"
      flash.now[:failed_en] == "Your country is not inputed."
      flash_set("You failed to send","投稿に失敗","error")
    elsif params["contact_data"][5] == ""
      flash.now[:failed_jp] == "内容が入力されていません。"
      flash.now[:failed_en] == "Detail is not inputed."
      flash_set("You failed to send","投稿に失敗","error")
    else
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


$(function(){
  $(".send_contact").on('click',function(){
    name = $(".content_input_form #content_name").val()
    username = $(".content_input_form #content_username").val()
    mail = $(".content_input_form #content_mail").val()
    phone = $(".content_input_form #content_phone").val()
    country = $(".content_input_form #content_country").val()
    message = $(".content_input_form #content_message").val()
    if(name == undefined){
      alert_modal("Your Realname is not inputed" ,"本名が入力されていません","fail")
    }
    else if(mail == undefined){
      alert_modal("Your Mail Address is not inputed" ,"メールアドレスが入力されていません","fail")
    }
    else if(mail.match(/^[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]$/)){
      alert_modal("Your Mail Address is wrong" ,"メールアドレスが間違っています","fail")
    }
    else if(phone == undefined){
      alert_modal("Your Phone Number is not inputed" ,"電話番号が入力されていません","fail")
    }
    else if(phone.match(/^(0[5-9]0[0-9]{8}|0[1-9][1-9][0-9]{7})$/)){
      alert_modal("Your Phone Number is wrong" ,"電話番号が間違っています","fail")
    }
    else if(country == undefined){
      alert_modal("Your Country is not inputed" ,"出身国が入力されていません","fail")
    }
    else if(message == undefined){
      alert_modal("Your Inquiry Details is not inputed" ,"お問い合わせ内容が入力されていません","fail")
    }
    else {
      alert_modal("You successed to send","投稿に成功しました","success")
    }
  })
})

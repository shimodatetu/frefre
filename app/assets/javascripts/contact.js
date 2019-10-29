/*
$(function(){
  $(".send_contact").on('click',function(){
    name = $(".content_input_form#content_name").val()
    username = $(".content_input_form#content_username").val()
    mail = $(".content_input_form#content_mail").val()
    phone = $(".content_input_form#content_phone").val()
    country = $(".content_input_form#content_country").val()
    message = $(".content_input_form#content_message").val()
    var regexp_mail = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/;
    if(name == ""){
      alert_modal("Your Realname is not inputed" ,"本名が入力されていません","fail")
    }
    else if(mail == ""){
      alert_modal("Your Mail Address is not inputed" ,"メールアドレスが入力されていません","fail")
    }
    else if(!regexp_mail.test(mail)){
      alert_modal("Your Mail Address is wrong" ,"メールアドレスが間違っています","fail")
    }
    else if(phone == ""){
      alert_modal("Your Phone Number is not inputed" ,"電話番号が入力されていません","fail")
    }
    else if(!phone.match(/^(0[5-9]0[0-9]{8}|0[1-9][1-9][0-9]{7})$/)){
      alert_modal("Your Phone Number is wrong" ,"電話番号が間違っています","fail")
    }
    else if(country == ""){
      alert_modal("Your Country is not inputed" ,"出身国が入力されていません","fail")
    }
    else if(message == ""){
      alert_modal("Your Inquiry Details is not inputed" ,"お問い合わせ内容が入力されていません","fail")
    }
  })
})
*/

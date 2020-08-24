now_alert = false
alert_time = 1500
function alert_modal(alert_en,alert_jp,alert_type){
  if(now_alert == false){
    $("#successModal .en").html(alert_en)
    $("#successModal .jp").html(alert_jp)
    $("#successModal").modal("show")
    $(".modal-backdrop").attr("style","display:none;")
    if(alert_type != null) {
      $(".modal-content").addClass(alert_type)
    }
    else {
      $(".modal-content").attr("class","modal-content")
    }
    now_alert = true
    if(alert_type == "success"){
      setTimeout(function(){
        $("#successModal").modal("hide")
        now_alert = false;
      },alert_time);
    }
  }
}

function alert_modal_js(alert_en,alert_jp,alert_type){
  document.querySelector("#successModal .en").innerHTML = alert_en
  document.querySelector("#successModal .jp").innerHTML = alert_jp
  document.querySelector("#successModal").modal("show")
  document.querySelector(".modal-backdrop").attr("style","display:none;")
  if(alert_type != null) {
    document.querySelector(".modal-content").addClass(alert_type)
  }
  else {
    document.querySelector(".modal-content").attr("class","modal-content")
  }
  setTimeout(function(){
    document.querySelector("#successModal").modal("hide")
  },alert_time);
}

function alert_get(){
  alert_en = localStorage.getItem("alert_en")
  alert_jp = localStorage.getItem("alert_jp")
  alert_type = localStorage.getItem("alert_type")
  if(alert_en != null && alert_jp != null && alert_type != null){
    alert_modal(alert_en,alert_jp,alert_type)
    alert_en = localStorage.removeItem("alert_en")
    alert_jp = localStorage.removeItem("alert_jp")
    alert_type = localStorage.removeItem("alert_type")
  }
}

function alert_set(alert_en_in,alert_jp_in,alert_type_in){
  alert_en = localStorage.setItem("alert_en",alert_en_in)
  alert_jp = localStorage.setItem("alert_jp",alert_jp_in)
  alert_type = localStorage.setItem("alert_type",alert_type_in)
}

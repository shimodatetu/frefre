function alert_modal(alert_en,alert_jp,alert_type){
  $("#successModal .en").html(alert_en)
  $("#successModal .jp").html(alert_jp)
  $("#successModal").modal("show")
  $(".modal-backdrop").attr("style","display:none;")
  if(alert_type != null) {
    $(".modal-content").addClass(alert_type)
  }
  setTimeout(function(){
    $("#successModal").modal("hide")
  },1500);
}

function alert_get(){
  alert_en = localStorage.getItem("alert_en")
  alert_jp = localStorage.getItem("alert_jp")
  alert_type = localStorage.getItem("alert_type")
  if(alert_en != null && alert_jp != null){
    alert_modal(alert_en,alert_jp,alert_type)
  }
  alert_en = localStorage.removeItem("alert_en")
  alert_jp = localStorage.removeItem("alert_jp")
  alert_type = localStorage.removeItem("alert_type")
}

function alert_set(alert_en_in,alert_jp_in,alert_type_in){
  alert_en = localStorage.setItem("alert_en",alert_en_in)
  alert_jp = localStorage.setItem("alert_jp",alert_jp_in)
  alert_type = localStorage.setItem("alert_type",alert_type_in)
}

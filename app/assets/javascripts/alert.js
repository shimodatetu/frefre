function alert_modal(alert_en,alert_jp){
  $("#successModal .en").append(alert_en)
  $("#successModal .jp").append(alert_jp)
  $("#successModal").modal("show")
  $(".modal-backdrop").attr("style","display:none;")
  setTimeout(function(){
    $("#successModal").modal("hide")
  },2000);
}

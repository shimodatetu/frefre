

$(function(){
  var first_value = 500;
  if(localStorage.getItem("frefre_slider") != null){
    first_value = localStorage.getItem("frefre_slider")
  }
  $('.lang_bar_cover #slider').slider({
    value:first_value,
    formatter: function(value) {
      if(true){
        localStorage.setItem("frefre_slider",value);
        var en_per = value / 10;
        var jp_per = (1000 - value) / 10;
        //var cover_width = window.innerWidth * 0.170
        //console.log(70/cover_width*500)
        if(value < 200){
          $(".en_position").attr("style","display:none;");
          $(".jp_position").attr("style","width:calc(100% - 25px)");
          $(".post_content_position_space").attr("style","display:none;");
        }
        else if(value > 800){
          $(".en_position").attr("style","width:calc(100% - 25px)");
          $(".jp_position").attr("style","display:none");
          $(".post_content_position_space").attr("style","display:none;");
        }
        else{
          $(".en_position").attr("style","width:calc("+en_per+"% - 25px)");
          $(".jp_position").attr("style","width:calc("+jp_per+"% - 25px)");
          $(".post_content_position_space").removeAttr("style");
        }
      }
    }
  });
  $(".slider-handle").append('<span class="slider_icon glyphicon glyphicon-resize-horizontal"></span>');
});



$(function(){
  if(localStorage.getItem("slider_position") == "close"){
    target_slider = document.getElementById("lang_bar_cover")
    if(target_slider != null){
      target_slider.style.marginTop = '-37px'
      document.getElementById("main_content_cover").style.paddingTop = "15px"
      //$('.lang_bar_cover').attr("style","margin-top:-37px");
      //$('.main_content_cover').attr("style","padding-top:15px");
    }
  }
  var first_value = 500;
  if(localStorage.getItem("frefre_slider") != null){
    first_value = localStorage.getItem("frefre_slider")
  }
  moving = false;
  $(".up_slider").on("click",function(){
    if(moving == false){
      //$(".up_slider").attr("style","display:none")
      //$(".down_slider").attr("style","display:inline-block")
      $('.lang_bar_cover').animate( {marginTop: '-37px'} , {duration: 200,queue: false});
      $(".main_content_cover").animate( {paddingTop: '15px'} , {duration: 200,queue: false});
      localStorage.setItem("slider_position","close")
      moving = true;
    }
    moving = false;
  });
  $(".down_slider").on("click",function(){
    if(moving == false){
      //$(".up_slider").attr("style","display:inline-block")
      //$(".down_slider").attr("style","display:none")
      $('.lang_bar_cover').animate( {marginTop: '5px'} , {duration: 200,queue: false});
      $(".main_content_cover").animate( {paddingTop: '60px'} , {duration: 200,queue: false});
      localStorage.setItem("slider_position","open")
      moving = true;
    }
    moving = false;
  });
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
          $(".jp_position").attr("style","width:calc(100%)");
          $(".post_content_position_space").attr("style","display:none;");
        }
        else if(value > 800){
          $(".en_position").attr("style","width:calc(100%)");
          $(".jp_position").attr("style","display:none");
          $(".post_content_position_space").attr("style","display:none;");
        }
        else{
          $(".en_position").attr("style","width:calc("+en_per+"% - 15px)");
          $(".jp_position").attr("style","width:calc("+jp_per+"% - 15px)");
          $(".post_content_position_space").removeAttr("style");
        }
      }
    }
  });
  $(".slider-handle").append('<span class="slider_icon glyphicon glyphicon-resize-horizontal"></span>');
});

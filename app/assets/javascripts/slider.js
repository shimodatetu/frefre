

$(function(){

  var first_value = 50;
  if(localStorage.getItem("frefre_slider") != null){
    first_value = localStorage.getItem("frefre_slider")
  }

  if( (frefre_button = localStorage.getItem("frefre_button") ) == null && window.innerWidth <= 750 ){
    en_button()
  }
  else if((frefre_button = localStorage.getItem("frefre_button") ) == null || frefre_button == "enjp_button"){
    enjp_button()
  }
  else if(frefre_button == "jp_button"){
    jp_button()
  }
  else if(frefre_button == "en_button"){
    en_button()
  }

  $(".lang_change .jp_button").on("click",function(){
    localStorage.setItem("frefre_button","jp_button");
    jp_button()
  })
  $(".lang_change .enjp_button").on("click",function(){
    localStorage.setItem("frefre_button","enjp_button");
    enjp_button()
  })
  $(".lang_change .en_button").on("click",function(){
    localStorage.setItem("frefre_button","en_button");
    en_button()
  })

  function jp_button(){
    $(".en_position").attr("style","display:none;");
    $(".jp_position").attr("style","width:calc(100%)");
    $(".post_content_position_space").attr("style","display:none;");
    $(".en_button").attr("id","");
    $(".enjp_button").attr("id","");
    $(".jp_button").attr("id","active");
    $(".float_button .jp_button").attr("style","display:none");
    $(".float_button .en_button").attr("style","display:block");
  }
  function enjp_button(){
    $(".en_position").attr("style","width:calc(50% - 12px)");
    $(".jp_position").attr("style","width:calc(50% - 12px)");
    $(".post_content_position_space").attr("style","");
    $(".en_button").attr("id","");
    $(".enjp_button").attr("id","active");
    $(".jp_button").attr("id","");
  }
  function en_button(){
    $(".jp_position").attr("style","display:none;");
    $(".en_position").attr("style","width:calc(100%)");
    $(".post_content_position_space").attr("style","display:none;");
    $(".en_button").attr("id","active");
    $(".enjp_button").attr("id","");
    $(".jp_button").attr("id","");
    $(".float_button .en_button").attr("style","display:none");
    $(".float_button .jp_button").attr("style","display:block");
  }

  $(".lang_bar_cover .en_country").on("click",function(){
    $('.min-slider-handle').animate({"left": "0%"}, {duration: 200,queue: false}, 'linear');
    $('.slider-selection').animate({"width": "0%"}, {duration: 200,queue: false}, 'linear');
    $('.slider-track-high').animate({"width": "100%"}, {duration: 200,queue: false}, 'linear');
    var slider_val = parseInt($("#slider").attr("value"))
    var move_by_time = parseInt(slider_val) / 20
    move_left(slider_val,move_by_time,20)
  })
  $(".lang_bar_cover .jp_country").on("click",function(){
    $('.min-slider-handle').animate({"left": "100%"}, {duration: 200,queue: false}, 'linear');
    $('.slider-selection').animate({"width": "100%"}, {duration: 200,queue: false}, 'linear');
    $('.slider-track-high').animate({"width": "0%"}, {duration: 200,queue: false}, 'linear');
    var slider_val = parseInt($("#slider").attr("value"))
    var move_by_time = (100 - parseInt(slider_val)) / 20
    move_right(slider_val,move_by_time,20)
  })
  $('.lang_bar_cover #slider').slider({
    value:first_value,
    formatter: function(value) {
      if(true){
        if($('.thread_all_post').length){
            left_max = 5
            right_max = 95
        }
        localStorage.setItem("frefre_slider",value);
        //var cover_width = window.innerWidth * 0.170
        move_slider(value)
      }
    }
  });
  $(".slider-handle").append('<span class="slider_icon glyphicon glyphicon-resize-horizontal"></span>');
  if(localStorage.getItem("slider_position") == "close"){
    target_slider = document.getElementById("lang_bar_cover")
    if(target_slider != null){
      target_slider.style.marginTop = '-37px'
      document.getElementById("main_content_cover").style.paddingTop = "15px"
      //$('.lang_bar_cover').attr("style","margin-top:-37px");
      //$('.main_content_cover').attr("style","padding-top:15px");
    }
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
});
function move_slider(value){
  var left_max = 15
  var right_max = 85
  var en_per = value;
  var jp_per = (100 - value);
  if(value < left_max){
  //if(value == 0){
    $(".en_position").attr("style","display:none;");
    $(".jp_position").attr("style","width:calc(100%)");
    $(".post_content_position_space").attr("style","display:none;");
  }
  else if(value > right_max){
  //else if(value == 1000){
    $(".en_position").attr("style","width:calc(100%)");
    $(".jp_position").attr("style","display:none");
    $(".post_content_position_space").attr("style","display:none;");
  }
  else{
    $(".en_position").attr("style","width:calc("+en_per+"% - 12px)");
    $(".jp_position").attr("style","width:calc("+jp_per+"% - 12px)");
    $(".post_content_position_space").removeAttr("style");
  }
}
function move_left(slider_val,move_by_time,times){
  if(times == 1){
    move_slider(0)
    $("#slider").attr("value","0")
    localStorage.setItem("frefre_slider","0");
  }
  else{
    slider_val -= move_by_time
    move_slider(slider_val)
    setTimeout(function(){
      move_left(slider_val,move_by_time,times - 1)
    }, 10);
  }
}
function move_right(slider_val,move_by_time,times){
  if(times == 1){
    move_slider(100)
    $("#slider").attr("value","100")
    localStorage.setItem("frefre_slider","100");
  }
  else{
    slider_val += move_by_time
    move_slider(slider_val)
    setTimeout(function(){
      move_right(slider_val,move_by_time,times - 1)
    }, 10);
  }
}
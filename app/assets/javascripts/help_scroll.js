$(function(){
  $(".help_design .scroll_button").on("click",function(){
    var id = $(this).attr("id") + "_position";
    console.log(id);
    var top = document.getElementById(id).getBoundingClientRect().top;
    scrollTo(0, top);
  })
})
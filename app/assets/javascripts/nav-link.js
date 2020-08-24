
$(function(){
  $('.nav-link').on('click',function(){
    url = new URL(location);
    get_path = $(this).attr("href").replace("#","")
    url.searchParams.set("navlink", get_path);
    history.replaceState(null,null,url.pathname+url.search);
　})
})

$(function(){
  $(".profile_image_input").on("change",function(){
    $('#image_submit').click();
  });
  $(".profile_history_change3").click(function(){
    url_split = location.href.split("/profile");
    url_id = url_split[1].split("/");
    url_words = '/profile/3'
    if(url_id[2] != undefined && url_id[3] != undefined){
      url_words = '/profile/3/'+url_id[2]+'/'+url_id[3]
    }
    history.replaceState(null,null,url_words);

    $('.page_button').each(function(i, elem){
      url = $(elem).attr("href")
      if(url != undefined){
        url_split = url.split("/")
        $(elem).attr("href","/profile/3/"+url_split[3]+"/"+url_split[4])
      }
    });
  })
  $(".profile_history_change2").click(function(){
    url_split = location.href.split("/profile");
    url_id = url_split[1].split("/");
    url_words = '/profile/2'
    if(url_id[2] != undefined && url_id[3] != undefined){
      url_words = '/profile/2/'+url_id[2]+'/'+url_id[3]
    }
    history.replaceState(null,null,url_words);
    $('.page_button').each(function(i, elem){
      url = $(elem).attr("href")
      if(url != undefined){
        url_split = url.split("/")
        $(elem).attr("href","/profile/2/"+url_split[3]+"/"+url_split[4])
      }
    });
  })
})

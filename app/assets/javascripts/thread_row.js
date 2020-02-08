$(function(){
  var last_elem;
  var id = -1;
  var left_value = 50;
  if(localStorage.getItem("frefre_slider") != null){
    left_value = localStorage.getItem("frefre_slider")
  }
  var right_value = 100 - left_value
  $('.thread_page .thread_cover').each(function(i, elem){
    var jp_height = $(elem).find(".jp_content_row .post_content_text").height();
    var en_height = $(elem).find(".en_content_row .post_content_text").height();
    if(jp_height == 0){jp_height = 999;}
    if(en_height == 0){en_height = 999;}
    var row = Math.ceil((Math.min(jp_height,en_height)) / 22);
    row += row * (50 - Math.min(left_value,right_value)) / 50 + 1
    $(elem).find(".jp_content_row .post_content_text").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    $(elem).find(".en_content_row .post_content_text").attr("style","-webkit-line-clamp:"+Math.ceil(row));

  });
  $('.pvpage_all .thread_cover').each(function(i, elem){
    var jp_height = $(elem).find(".jp_position .post_content_text").height();
    var en_height = $(elem).find(".jp_position .post_content_text").height();
    var row = (Math.max(jp_height,en_height) - 10) / 22;
    if (row <= 1.0){
      $(elem).find(".jp_position .post_content_text").attr("style","-webkit-line-clamp:1");
      $(elem).find(".en_position .post_content_text").attr("style","-webkit-line-clamp:1");
      $(elem).find(".jp_position .post_content").attr("style","-webkit-line-clamp:1");
      $(elem).find(".en_position .post_content").attr("style","-webkit-line-clamp:1");
    }
  });
  var options ={"backdrop":"static"}

  $(".cannot_delete").on("click", function (event) {
    alert_modal("You cannot delete this by the event acount.","イベント用アカウントでは削除できません","fail")
  })

  $('#deleteModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) //モーダルを呼び出すときに使われたボタンを取得
    var recipient = button.data('whatever') //data-whatever の値を取得
    var recipient2 = $(".thread_cover" + "#"+recipient).prop('outerHTML')//data-whereverの値を取得
    var modal = $(this)  //モーダルを取得
    modal.find('.delete_id').attr("value",recipient) //モーダルのタイトルに値を表示
    modal.find(".delete_html").html(recipient2)
  })

  $(".zoom_modal_open").on("click",function(){
    src = $(this).children("img").attr("src")
    $("#zoom_modal img").attr("src",src)
  })
});

$(function(){
  $(".thread_send .btn_send").on("click",function(){
    ok = true
    if(ok == true){
      var key = window.ENV.RailsEnv
      $.ajax({
        url: "https://apigw.mirai-api.net/trial/mt/v1.0/translate",
        type: 'POST',
        data: { apikey:key, en: 'おはよう' }
      }).then(data　=> {
        console.log(data.results[0]['reply']),
        error => alert('エラー')
      });
      ok = false
    }
  })


  var last_elem;
  var id = -1;
  $('.thread_page .thread_cover').each(function(i, elem){
    var jp_height = $(elem).find(".jp_content_row .post_content_text").height();
    var en_height = $(elem).find(".en_content_row .post_content_text").height();
    var row = (Math.max(jp_height,en_height) - 10) / 22;
    $(elem).find(".jp_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    $(elem).find(".en_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
  });
  $('.pvpage_all .thread_cover').each(function(i, elem){
    var jp_height = $(elem).find(".jp_position .post_content_text").height();
    var en_height = $(elem).find(".jp_position .post_content_text").height();
    var row = (Math.max(jp_height,en_height) - 10) / 22;
    if (row < 2.0){
      $(elem).find(".jp_position .post_content_text").attr("style","-webkit-line-clamp:1");
      $(elem).find(".en_position .post_content_text").attr("style","-webkit-line-clamp:1");
      $(elem).find(".jp_position .post_content").attr("style","-webkit-line-clamp:1");
      $(elem).find(".en_position .post_content").attr("style","-webkit-line-clamp:1");
    }
  });
  var options ={"backdrop":"static"}

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

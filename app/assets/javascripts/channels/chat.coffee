
window.translated = false
App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server
  received: (data) ->
    console.log(data)
    console.log($(".get_user_id").attr("id"))
    if data["user"] == $(".get_user_id").attr("id")
      page_id = String(parseInt(Number(data["chat_num"]) / 20) + 1)
      if location.href != "/profile/5/"+data['notice_id']+"/"+page_id
        location.href = "/profile/5/"+data['notice_id']+"/"+page_id
  make: (lang,mes_jp,mes_en, group)->
    window.translated = false
    mes_jp = mes_jp.replace("// n", '').replace("//n", '');
    mes_en = mes_en.replace("//n", '').replace("// n", '');
    alert_modal("You successed to post.","投稿に成功しました","success")
    @perform('make',group_id:group,content_jap:mes_jp,content_eng:mes_en,lang:lang)
    $(".base_en_form").val("")
    $(".base_jp_form").val("")
    $('#chatModal-enjp').modal("hide")

  image: (file,group)->
    window.translated = false
    @perform('image',group_id:group,image:file,lang:"none")

reader = new FileReader
reader.addEventListener 'load', ->
  text = "<img src='" + String(reader.result) + "'>"
  App.chat.image(reader.result,parseInt($("#group").val()))

$(document).on 'change', '.chat_image_post .post_file', (event) ->
  if (this.files[0].type != 'text/plain')
    reader.readAsDataURL(this.files[0], 'UTF-8');

$(document).on 'click', '.chat_send .btn_send', (event) ->
  if($(this).attr("name") == "logined")
    type_check(this.id);
  else
    alert_modal("You can't post a comment because you haven't logined.","ログインしていないので書き込めません。","fail")


$(document).on 'click', '#chatModal-enjp .btn_send', (event) ->
  text_en = $("#chatModal-enjp .en_form").val();
  text_jp = $("#chatModal-enjp .jp_form").val();
  App.chat.make("none",text_jp,text_en,parseInt($("#group").val()))

add_post=(data)->
  plus_post = $(data["message"])
  $(".thread_cover").append plus_post
  plus_post.ready ->
    $(".delete_button_destroy").click();
    jp_height = plus_post.find(".jp_content_row .post_content_text").height();
    en_height = plus_post.find(".en_content_row .post_content_text").height();
    row = (Math.max(jp_height,en_height) - 10) / 22;
    plus_post.find(".jp_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    plus_post.find(".en_content_row").attr("style","-webkit-line-clamp:"+Math.ceil(row));
    slider = $(".slider-handle").attr("aria-valuenow");
    en_per = slider / 10;
    jp_per = (1000 - slider) / 10;
    if slider < 100
      plus_post.find(".en_position").attr("style","display:none;");
      plus_post.find(".jp_position").attr("style","width:calc(100%)");
      plus_post.find(".post_content_position_space").attr("style","display:none;");
    else if slider > 900
      plus_post.find(".en_position").attr("style","width:calc(100%)");
      plus_post.find(".jp_position").attr("style","display:none");
      plus_post.find(".post_content_position_space").attr("style","display:none;");
    else
      plus_post.find(".en_position").attr("style","width:calc("+en_per+"% - 15px)");
      plus_post.find(".jp_position").attr("style","width:calc("+jp_per+"% - 15px)");
      plus_post.find(".post_content_position_space").removeAttr("style");

prohibit_check=(text_en,text_jp)->
  can_post = true
  check_text_en = text_en.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '')
  check_text_jp = text_jp.toLowerCase().replace(/-/g, '').replace(/\./g, '').replace(/_/g, '').replace(/ /g, '')
  gon.prohibit.forEach (prohibit) ->
    if check_text_en.match?(prohibit) || check_text_jp.match?(prohibit)
      console.log("not")
      can_post = false
      return
  return can_post

type_check=(id)->
  text_en = $(".base_en_form").val();
  text_jp = $(".base_jp_form").val();
  if id == "post"
    if text_en != "" && text_jp != ""
      if prohibit_check(text_en,text_jp) == true
        App.chat.make("none",text_jp,text_en,parseInt($("#group").val()))
      else
        alert_modal("You cannot post because it contains prohibited words.","禁止ワードが含まれているので投稿できません。","fail");
    else if text_jp != ""
      alert_modal("The English is empty.","英語入力欄に何も書かれていません","fail");
    else if text_en != ""
      alert_modal("The Japanese form is empty.","日本語入力欄に何も書かれていません","fail");
    else
      alert_modal("This form is empty.","入力欄に何も書かれていません","fail");
  else if window.translated == true && 1 == 2
    alert_modal("You can translate at once.","一度しか翻訳できません。","fail")
  else if id == "trans_to_en"
    if text_jp == ""
      alert_modal("The Japanese form is empty.","日本語入力欄に何も書かれていません","fail");
    else
      #translate_google("en",text_jp)
      $("#fakeLoader").fakeLoader({},translate_google,["ja",text_jp]);
  else if id == "trans_to_jp"
    if text_en == ""
      alert_modal("The English is empty.","英語入力欄に何も書かれていません","fail");
    else
      #translate_google("ja",text_en)
      $("#fakeLoader").fakeLoader({},translate_google,["ja",text_en]);



translate_google=(data) ->
  lang = data[0]
  words = data[1]
  ajax_send = $.ajax(
    async: false
    url: 'https://still-plains-44123.herokuapp.com/trans_mirai',
    type: 'post'
    data:
      'lang': lang
      'words': words
    dataType: 'json').done((res) ->
    window.translated = true
    translation = res[0]
    if lang == "ja"
      $(".base_jp_form").val(translation);
    else
      translation = translation.replace("&#39;","'")
      $(".base_en_form").val(translation);
    $("#fakeLoader").fadeOut();
    return
  ).fail (xhr, status, error) ->
    alert status
    $("#fakeLoader").fadeOut();
    return

  $(document).on 'click', '.fakeloader_cancel_button', (event) ->
    ajax_send.abort();
    $("#fakeLoader").fadeOut();

bytes=(str) ->
  return(encodeURIComponent(str).replace(/%../g,"x").length);
isHalf=(str)->
  str_length = str.length
  str_byte = bytes(str)
  return str_length == str_byte

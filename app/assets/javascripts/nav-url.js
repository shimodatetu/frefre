hash = window.location.hash
  hash and $("ul.nav a[href=\"" + hash + "\"]").tab("show")
  $(".nav-tabs a").click (e) ->
    $(this).tab "show"
    scrollmem = $("body").scrollTop()
    window.location.hash = @hash
    $("html,body").scrollTop scrollmem
$ ->
  $("#submit_review").on "click", (event) ->
    event.preventDefault()
    if $("input[name='score']").val() is ""
      alert "Your rating can't be blank"
      return true
    if $("textarea[name='review']").val() is ""
      alert "Your review can't be blank"
      return true
    form = $("form[name='review']")
    $.ajax
      url: form.attr("action")
      type: "POST"
      success: (review) ->
        $("textarea[name='review']").val("")
        reviews_div = $(".reviews")
        review_div = $("<div class='info view' style='text-align: left;'></div>")
        author = $("<p><img src=#{review['user']['image']}> #{review['user']['name']} (#{review['created_at']})</p>")
        div_star = $("<div id=star#{review['id']}></div>")
        body_review = $("<p>#{review['body']}</p>")
        review_div.append(author).append(div_star).append(body_review)
        reviews_div.prepend(review_div)
        $("#star#{review['id']}").raty({readOnly: true, score: review['note']})
      complete: ->
      data: form.serialize()

$ ->
  $("#submit_review").on "click", (event) ->
    event.preventDefault()
    form = $("form[name='review']")
    $.ajax
      url: form.attr("action")
      type: "POST"
      success: (review) ->
        $("textarea[name='review']").val("")
        reviews_div = $(".reviews")
        review_div = $("<div class='info view' style='text-align: left;'></div>")
        author = $("<p><img src=#{review['user']['image']}> #{review['user']['name']} (#{review['created_at']})</p>")
        body_review = $("<p>#{review['body']}</p>")
        review_div.append(author)
        review_div.append(body_review)
        reviews_div.prepend(review_div)
      complete: ->
      data: form.serialize()

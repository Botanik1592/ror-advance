App.cable.subscriptions.create('AnswersChannel', {
  connected: ->
    question_id = $("#question").data("id")
    if question_id
      @perform 'follow_answers', id: question_id
    else
      @perform 'unfollow'
  ,
  received: (data)  ->
    $('.answers').append(JST["templates/answer"]({data: data}))
})

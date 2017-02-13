App.cable.subscriptions.create('CommentsChannel', {
  connected: ->
    question_id = $("#question").data("id")
    if question_id
      @perform 'follow_comments', question_id: question_id
    else
      @perform 'unfollow'
  ,
  received: (data)  ->
    target = '#comments-' + data['commentable_type'] + '-' + data['commentable_id']
    $(target + ' ul').append(JST["templates/comment"]({comment: data.comment}))
})

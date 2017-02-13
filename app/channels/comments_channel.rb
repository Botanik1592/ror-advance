class CommentsChannel < ApplicationCable::Channel
  def follow_comments(data)
    stream_from "comments_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end
end

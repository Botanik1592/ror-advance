class SendAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |user|
      AnswerMailer.notification(user, answer).deliver_later
    end
  end
end
